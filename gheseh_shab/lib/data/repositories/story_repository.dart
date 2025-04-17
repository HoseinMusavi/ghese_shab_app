import 'package:dio/dio.dart';
import 'package:gheseh_shab/data/models/story_model.dart';

class StoryRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://qesseyeshab.ir/api"));

  Future<List<StoryModel>> fetchStories(
      {String? search, String? filter}) async {
    try {
      final response = await _dio.get(
        '/stories',
        queryParameters: {
          if (search != null) 'search': search,
          if (filter != null) 'filter': filter,
        },
      );

      if (response.statusCode == 200) {
        print("response.data=${response.data}");
        final data = response.data['stories'] as List<dynamic>?;

        if (data == null) {
          throw Exception("داده‌های دریافتی نامعتبر هستند.");
        }

        return data.map((e) => StoryModel.fromJson(e)).toList();
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
