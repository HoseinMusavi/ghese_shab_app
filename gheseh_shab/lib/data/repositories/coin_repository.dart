import 'package:dio/dio.dart';

class CoinRepository {
  final Dio dio;
  final authRepository;

  CoinRepository({required this.dio, required this.authRepository});

  Future<String> depositCoins(int amount) async {
    try {
      // دریافت توکن احراز هویت از UserRepository
      final token = await authRepository.getToken();
      authRepository.printToken();
      if (token == null) {
        throw Exception("توکن یافت نشد. لطفاً وارد شوید.");
      }
      // تنظیم هدر با توکن
      final response = await dio.post(
        '/account/deposit',
        data: {'amount': amount},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // اضافه کردن توکن به هدر
          },
        ),
      );

      if (response.data['status'] == 'ok') {
        return response.data['pay_link']; // لینک پرداخت
      } else {
        throw Exception(response.data['message'] ?? 'خطا در خرید سکه');
      }
    } catch (e) {
      throw Exception('مشکلی در اتصال به سرور وجود دارد');
    }
  }
}
