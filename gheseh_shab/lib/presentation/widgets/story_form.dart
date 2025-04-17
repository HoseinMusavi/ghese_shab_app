import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:gheseh_shab/presentation/widgets/story_info.dart';

import 'package:just_audio/just_audio.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;

  const StoryCard({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // هدایت به صفحه اطلاعات داستان
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryInfoPage(story: story),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // تصویر داستان
            CachedNetworkImage(
              imageUrl: 'https://qesseyeshab.ir${story.image}',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
            // گرادیان برای زیبایی
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // دکمه پخش و مدت زمان
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDurationTag(),
                  _buildPlayButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ویجت نمایش مدت زمان
  Widget _buildDurationTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${story.length} دقیقه",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  // ویجت دکمه پخش
  Widget _buildPlayButton() {
    return const Icon(
      Icons.play_circle_fill,
      color: Colors.blueAccent,
      size: 40,
    );
  }
}
