import 'package:dio/dio.dart';

class LoginRepository {
  final Dio _dio;

  LoginRepository(this._dio);

  Future<Response> sendPhoneNumber(String phoneNumber) async {
    try {
      final response = await _dio.post(
        'https://qesseyeshab.ir/api/auth',
        data: {
          'phone': phoneNumber,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
