import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://qesseyeshab.ir/api', // آدرس پایه API
    ),
  );

  Future<String?> fetchAudioUrl({
    required String storyId,
    String? token,
    required String sessionId,
    required String guestId,
  }) async {
    final userAgent = 'YourAppName/1.0'; // مقدار userAgent
    final os = 'android'; // سیستم عامل (android یا ios)

    try {
      final response = await _dio.get(
        '/story/$storyId/play',
        queryParameters: {
          'token': token ?? guestId,
          'session': sessionId,
          'os': os,
          'userAgent': userAgent,
        },
      );
      print('music url=${response.data}');
      print('mosic url=${response.headers}');
      // بررسی وضعیت پاسخ
      if (response.statusCode == 200) {
        return response.headers['location']?.first; // لینک فایل صوتی
      }
    } catch (e) {
      print('Error fetching audio URL: $e');
    }
    return null;
  }

  Future<void> sendPlaybackProgress({
    required String storyId,
    required String sessionId,
    required int currentPosition,
  }) async {
    try {
      await _dio.post(
        '/story/$storyId/play/progress',
        data: {
          'session': sessionId,
          'storyId': storyId,
          'until': currentPosition,
        },
      );
    } catch (e) {
      print('Error sending playback progress: $e');
    }
  }
}
