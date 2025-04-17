import 'package:dio/dio.dart';
import 'package:gheseh_shab/data/models/user_model.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';

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
}
