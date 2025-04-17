import 'package:dio/dio.dart';
import 'package:gheseh_shab/data/models/categories_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepository {
  final Dio dio;

  CategoryRepository({required this.dio});

  Future<List<Category>> fetchCategories() async {
    try {
      // دریافت توکن احراز هویت
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // if (token == null) {
      //   throw Exception("توکن احراز هویت یافت نشد.");
      // }

      // ارسال درخواست به API
      final response = await dio.get(
        '/categories',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['categories'] as List<dynamic>;
        return data.map((e) => Category.fromJson(e)).toList();
      } else {
        throw Exception(
            "خطای سرور: ${response.statusCode} - ${response.statusMessage}");
      }
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
