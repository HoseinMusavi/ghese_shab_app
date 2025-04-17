import 'package:dio/dio.dart';
import 'package:gheseh_shab/data/models/user_model.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository {
  final Dio dio;
  final AuthRepository authRepository;

  UserRepository({required this.dio, required this.authRepository});

  /// دریافت اطلاعات کاربر از API
  Future<UserModel> fetchUserInfo() async {
    try {
      // دریافت توکن از AuthRepository
      final token = await authRepository.getToken();
      authRepository.printToken();
      if (token == null) {
        throw Exception("توکن یافت نشد. لطفاً وارد شوید.");
      }

      // ارسال درخواست به API
      final response = await dio.get(
        '/user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // ارسال توکن در هدر
          },
        ),
      );

      // بررسی وضعیت پاسخ
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception(
            "خطا در دریافت اطلاعات کاربر: ${response.statusMessage}");
      }
    } on DioError catch (dioError) {
      throw Exception("خطای شبکه: ${dioError.message}");
    } catch (e) {
      throw Exception("خطای ناشناخته: $e");
    }
  }

  Future<Map<String, dynamic>> updateAccount({
    required String firstName,
    required String lastName,
    required String birthday,
    required String gender,
    required String country,
    required String province,
    required String city,
    XFile? image,
  }) async {
    final token = await authRepository.getToken(); // دریافت توکن کاربر
    final formData = FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'birthday': birthday,
      'gender': gender,
      'country': country,
      'province': province,
      'city': city,
      if (image != null)
        'image': await MultipartFile.fromFile(image.path, filename: image.name),
    });

    final response = await dio.post(
      '/account/update',
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return response.data;
  }
}
