import 'package:dio/dio.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';

class InviteRepository {
  final Dio dio;
  final AuthRepository authRepository;

  InviteRepository({required this.dio, required this.authRepository});

  Future<List<dynamic>> fetchInvitedUsers() async {
    try {
      // دریافت توکن از AuthRepository
      final token = await authRepository.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('توکن یافت نشد. لطفاً وارد شوید.');
      }

      // ارسال درخواست با هدر Authorization
      final response = await dio.get(
        '/account/invited',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // اضافه کردن توکن به هدر
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        return response.data['invited'] as List<dynamic>;
      } else {
        throw Exception('خطا در دریافت اطلاعات دعوت‌شدگان');
      }
    } on DioError catch (dioError) {
      throw Exception('خطای شبکه: ${dioError.message}');
    } catch (e) {
      throw Exception('خطای ناشناخته: $e');
    }
  }
}
