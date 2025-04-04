import 'package:dio/dio.dart';
import 'package:gheseh_shab/data/models/story_model.dart';

class Story_Repository {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://qesseyeshab.ir/api"));

  Future<List<StoryModel>> fetchStories() async {
    try {
      final response = await _dio.get('/stories');

      if (response.statusCode == 200) {
        final data1 = response.data['stories'] as List<dynamic>?;

        print('data: $data1');
        if (data1 == null) {
          throw Exception("داده‌های دریافتی نامعتبر هستند.");
        }
        List<StoryModel> stories =
            data1.map((e) => StoryModel.fromJson(e)).toList();

        return stories;
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
