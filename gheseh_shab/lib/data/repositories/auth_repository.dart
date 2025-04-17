import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository({required this.dio});

  /// ارسال شماره موبایل برای احراز هویت
  Future<Response> sendPhoneNumber(String phoneNumber) async {
    try {
      final response = await dio.post(
        '/auth',
        data: {
          'phone': phoneNumber,
        },
      );
      return response;
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        throw Exception(
            "خطای سرور: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}");
      } else {
        throw Exception("خطای شبکه: ${dioError.message}");
      }
    } catch (e) {
      throw Exception("خطای ناشناخته: $e");
    }
  }

  /// تأیید کد ارسال‌شده به شماره موبایل
  Future<Response> verifyCode(String phoneNumber, String code) async {
    try {
      print('شماره و کد ارسال شدن');
      print('phoneNumber: $phoneNumber');
      print('code: $code');

      final response = await dio.post(
        '/auth/verify',
        data: {
          'phone': phoneNumber,
          'code': code,
        },
      );
      return response;
    } catch (e) {
      throw Exception("خطا در تأیید کد: $e");
    }
  }

  /// ورود با شماره موبایل و رمز عبور
  Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      if (response.data['status'] == 'ok') {
        // ذخیره توکن در حافظه محلی
        await saveToken(response.data['token']);
      }

      return response.data;
    } catch (e) {
      throw Exception("خطا در ورود: $e");
    }
  }

  /// ارسال درخواست فراموشی رمز عبور
  Future<Response> forgotPassword(String phone) async {
    try {
      final response = await dio.post(
        '/auth/forgot-password',
        data: {
          'phone': phone,
        },
      );
      return response;
    } catch (e) {
      throw Exception("خطا در فراموشی رمز عبور: $e");
    }
  }

  /// ذخیره توکن در حافظه محلی
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// دریافت توکن از حافظه محلی
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// حذف توکن از حافظه محلی
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// بازنشانی رمز عبور
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String password,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        '/auth/reset-password',
        data: {
          'phone': phone,
          'password': password,
          'code': code,
        },
      );

      if (response.data['status'] == 'ok') {
        // ذخیره توکن جدید در حافظه محلی
        await saveToken(response.data['token']);
      }

      return response.data;
    } catch (e) {
      throw Exception("خطا در بازنشانی رمز عبور: $e");
    }
  }

  /// ثبت نام کاربر
  Future<Map<String, dynamic>> register({
    required String phone,
    required String firstName,
    required String lastName,
    required String password,
    required String code,
    String inviteCode = '',
  }) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'phone': phone,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
          'code': code,
          'invite_code': inviteCode,
        },
      );

      if (response.data['status'] == 'ok') {
        // ذخیره توکن در حافظه محلی
        await saveToken(response.data['token']);
      }

      return response.data;
    } catch (e) {
      throw Exception("خطا در ثبت‌نام: $e");
    }
  }

  void printToken() async {
    final authRepository = AuthRepository(dio: Dio());
    final token = await authRepository.getToken();

    if (token != null) {
      print("توکن ذخیره‌شده: $token");
    } else {
      print("توکن یافت نشد.");
    }
  }

  /// ارسال درخواست با پارامترهای search و filter و توکن در هدر
  Future<Response> fetchWithParams({
    required String endpoint,
    String? search,
    String? filter,
  }) async {
    try {
      // دریافت توکن ذخیره‌شده
      final token = await getToken();

      // ساخت هدر با توکن
      final headers = {
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // ساخت پارامترهای URL
      final queryParams = {
        if (search != null) 'search': search,
        if (filter != null) 'filter': filter,
      };

      // ارسال درخواست GET با پارامترها و هدر
      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      return response;
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        throw Exception(
            "خطای سرور: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}");
      } else {
        throw Exception("خطای شبکه: ${dioError.message}");
      }
    } catch (e) {
      throw Exception("خطای ناشناخته: $e");
    }
  }
}
