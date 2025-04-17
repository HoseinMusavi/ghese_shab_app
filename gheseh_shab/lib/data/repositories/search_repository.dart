import 'package:dio/dio.dart';
import '../models/story_model.dart';

class SearchRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://qesseyeshab.ir/api"));

  Future<List<StoryModel>> searchStories({
    String? author,
    String? announcer,
    String? typeOfWork,
    String? language,
    String? playlists,
    String? search,
  }) async {
    try {
      // ارسال درخواست به API
      final response = await _dio.get('/search', queryParameters: {
        'author': author,
        'announcer': announcer,
        'type_of_work': typeOfWork,
        'language': language,
        'playlist': playlists,
        'search': search,
      });

      // بررسی وضعیت پاسخ
      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        // تبدیل داده‌های دریافتی به لیستی از StoryModel
        final List<dynamic> storiesData = response.data['stories'];
        return storiesData.map((story) => StoryModel.fromJson(story)).toList();
      } else {
        throw Exception('Failed to fetch stories');
      }
    } catch (e) {
      // مدیریت خطا
      throw Exception('Error occurred while fetching stories: $e');
    }
  }

  Future<Map<String, dynamic>> fetchFilters() async {
    try {
      // ارسال درخواست به API
      final response = await _dio.get('/filters');

      // بررسی وضعیت پاسخ
      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        return {
          'announcers': response.data['announcers'],
          'playlists': response.data['playlists'],
          'languages': response.data['languages'],
          'authors': response.data['authors'],
          'type_of_works': response.data['type_of_works'],
        };
      } else {
        throw Exception('Failed to fetch filters');
      }
    } catch (e) {
      // مدیریت خطا
      throw Exception('Error occurred while fetching filters: $e');
    }
  }
}
