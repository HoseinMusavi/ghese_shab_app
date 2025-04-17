import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:gheseh_shab/data/repositories/play_link_repository.dart';
import 'package:gheseh_shab/presentation/widgets/music_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryInfoPage extends StatelessWidget {
  final StoryModel story;
  final ApiService _apiService = ApiService();

  StoryInfoPage({Key? key, required this.story}) : super(key: key);

  void _playStory(BuildContext context) async {
    final sessionId = _generateSessionId(); // تولید sessionId
    final guestId = _getGuestId(); // دریافت guestId
    final token = _getAuthToken(); // دریافت توکن احراز هویت

    final audioUrl = await _apiService.fetchAudioUrl(
      storyId: story.id.toString(),
      token: token,
      sessionId: sessionId,
      guestId: guestId.toString(),
    );

    if (audioUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MusicPlayerPage(
            story: story,
            audioUrl: audioUrl,
            sessionId: sessionId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خطا در دریافت فایل صوتی'),
        ),
      );
    }
  }

  void _buyStory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('خرید داستان انجام شد!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<String> _getGuestId() async {
    // دریافت guestId از SharedPreferences یا تولید آن در صورت عدم وجود
    try {
      // استفاده از SharedPreferences برای ذخیره و بازیابی guestId
      final prefs = await SharedPreferences.getInstance();
      final guestId = prefs.getString('guest_id');
      if (guestId != null) {
        return guestId; // بازگرداندن guestId ذخیره شده
      } else {
        // تولید guestId جدید و ذخیره آن
        final newGuestId = _generateGuestId();
        await prefs.setString('guest_id', newGuestId);
        return newGuestId;
      }
    } catch (e) {
      // در صورت بروز خطا، یک guestId پیش‌فرض تولید می‌شود
      return _generateGuestId();
    }
  }

  String _generateGuestId() {
    // تولید یک guestId یکتا با استفاده از UUID
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String? _getAuthToken() {
    // دریافت توکن احراز هویت از ریپازیتوری
    final dio = Dio(); // Ensure you import 'package:dio/dio.dart';
    final authRepository = AuthRepository(dio: dio);
    return authRepository.getToken().toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // تصویر و اطلاعات بالای صفحه
              _buildTopSection(context, isDarkMode),
              const SizedBox(height: 24),

              // توضیحات داستان
              Text(
                story.info ?? 'توضیحات داستان موجود نیست.',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),

              // اطلاعات داستان
              _buildStoryDetails(context, isDarkMode),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // تصویر داستان
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: 'https://qesseyeshab.ir${story.image}',
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
          ),
        ),
        const SizedBox(height: 16),

        // بخش زمان و دکمه پخش
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.timer,
                  color: isDarkMode ? Colors.white70 : Colors.black54),
              const SizedBox(width: 8),
              Text(
                '${story.length ?? 0} دقیقه',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  _playStory(context);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('پخش'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.green : Colors.teal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // بخش توضیحات و دکمه خرید
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'بعد از شنیدن نمونه صوتی، می‌توانید با استفاده از '
                'حساب اعتباری خود، فایل کامل را خریداری کنید.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _buyStory(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.teal : Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'خرید',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${story.price ?? 3} سکه',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryDetails(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            context,
            "مجموعه:",
            story.categoryId?.toString() ?? "نامشخص",
            isDarkMode,
          ),
          _buildDetailRow(
              context, "نویسنده:", story.author ?? "ناشناس", isDarkMode),
          _buildDetailRow(
              context, "تصویرگر:", story.imaging ?? "نامشخص", isDarkMode),
          _buildDetailRow(
              context, "مترجم:", story.translator ?? "نامشخص", isDarkMode),
          _buildDetailRow(
              context, "گوینده:", story.announcer ?? "نامشخص", isDarkMode),
          _buildDetailRow(
              context, "ویراستار:", story.editor ?? "نامشخص", isDarkMode),
          _buildDetailRow(
              context, "نوع اثر:", story.typeOfWork ?? "نامشخص", isDarkMode),
          _buildDetailRow(context, "گونه ادبی:",
              story.literaryStyle ?? "نامشخص", isDarkMode),
          _buildDetailRow(
              context, "عنوان اصلی:", story.mainTitle ?? "نامشخص", isDarkMode),
          _buildDetailRow(
              context, "زبان:", story.language ?? "نامشخص", isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl, // راست‌چین کردن ساختار
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.right, // راست‌چین کردن متن
              text: TextSpan(
                text: "$title ",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // افزایش اندازه فونت
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                children: [
                  TextSpan(
                    text: value,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 18, // افزایش اندازه فونت
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12), // فاصله بین متن و آیکون
          Icon(
            _getIconForTitle(title),
            color: _getIconColorForTitle(title, isDarkMode),
            size: 28, // افزایش اندازه آیکون
          ),
        ],
      ),
    );
  }

  Color _getIconColorForTitle(String title, bool isDarkMode) {
    switch (title) {
      case "مجموعه:":
        return isDarkMode ? Colors.blueAccent : Colors.blue;
      case "نویسنده:":
        return isDarkMode ? Colors.greenAccent : Colors.green;
      case "تصویرگر:":
        return isDarkMode ? Colors.orangeAccent : Colors.orange;
      case "مترجم:":
        return isDarkMode ? Colors.purpleAccent : Colors.purple;
      case "گوینده:":
        return isDarkMode ? Colors.redAccent : Colors.red;
      case "ویراستار:":
        return isDarkMode ? Colors.tealAccent : Colors.teal;
      case "نوع اثر:":
        return isDarkMode ? Colors.amberAccent : Colors.amber;
      case "گونه ادبی:":
        return isDarkMode ? Colors.cyanAccent : Colors.cyan;
      case "عنوان اصلی:":
        return isDarkMode ? Colors.pinkAccent : Colors.pink;
      case "زبان:":
        return isDarkMode ? Colors.lightBlueAccent : Colors.lightBlue;
      default:
        return isDarkMode ? Colors.grey : Colors.black54;
    }
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case "مجموعه:":
        return Icons.category;
      case "نویسنده:":
        return Icons.person;
      case "تصویرگر:":
        return Icons.brush;
      case "مترجم:":
        return Icons.translate;
      case "گوینده:":
        return Icons.mic;
      case "ویراستار:":
        return Icons.edit;
      case "نوع اثر:":
        return Icons.book;
      case "گونه ادبی:":
        return Icons.style;
      case "عنوان اصلی:":
        return Icons.title;
      case "زبان:":
        return Icons.language;
      default:
        return Icons.info;
    }
  }
}

class StoryPlayer extends StatelessWidget {
  final StoryModel story;
  final ScrollController scrollController;

  const StoryPlayer({
    Key? key,
    required this.story,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            story.name ?? 'داستان ناشناخته',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                CachedNetworkImage(
                  imageUrl: 'https://qesseyeshab.ir${story.image}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                ),
                const SizedBox(height: 16),
                Text(
                  story.info ?? 'توضیحات داستان موجود نیست.',
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
