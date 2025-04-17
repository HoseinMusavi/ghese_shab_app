import 'package:flutter/material.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:gheseh_shab/data/repositories/play_link_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

class MusicPlayerPage extends StatefulWidget {
  final StoryModel story;
  final String audioUrl;
  final String sessionId;

  const MusicPlayerPage({
    Key? key,
    required this.story,
    required this.audioUrl,
    required this.sessionId,
  }) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService _apiService = ApiService();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.setUrl(widget.audioUrl);
    _audioPlayer.play();

    // ارسال پیشرفت پخش هر 5 ثانیه
    _startProgressTracking();

    // گوش دادن به تغییرات مدت زمان کل
    _audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration ?? Duration.zero;
        });
      }
    });

    // گوش دادن به تغییرات موقعیت فعلی
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    });

    // گوش دادن به وضعیت پخش
    _audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        if (playerState.processingState == ProcessingState.completed) {
          // بازگشت به ابتدای فایل و توقف پخش
          _audioPlayer.seek(Duration.zero);
          setState(() {
            isPlaying = false;
            currentPosition = Duration.zero;
          });
        }
      }
    });
  }

  void _startProgressTracking() {
    _audioPlayer.positionStream.listen((position) {
      _apiService.sendPlaybackProgress(
        storyId: widget.story.id.toString()!,
        sessionId: widget.sessionId,
        currentPosition: position.inSeconds,
      );
    });
  }

  @override
  void dispose() {
    // لغو استریم‌ها
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseAudio() async {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      try {
        if (_audioPlayer.playerState.processingState == ProcessingState.idle) {
          // اگر منبع صوتی هنوز تنظیم نشده باشد
          await _audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(widget.audioUrl)),
          );
        }
        await _audioPlayer.play();
      } catch (e) {
        debugPrint('Error playing audio: $e');
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      await _audioPlayer.pause();
    }
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _rewindAudio() {
    final newPosition = currentPosition - const Duration(seconds: 10);
    _seekAudio(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _forwardAudio() {
    final newPosition = currentPosition + const Duration(seconds: 30);
    _seekAudio(newPosition > totalDuration ? totalDuration : newPosition);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // هماهنگی با تم برنامه
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://qesseyeshab.ir${widget.story.image}',
              height: 300, // بزرگ‌تر کردن تصویر
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 30, // ارتفاع ثابت برای متن
              child: Marquee(
                text: widget.story.name ?? 'عنوان ناشناخته',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // فونت کوچک‌تر
                    ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 120, // فاصله بیشتر بین جملات تکرارشونده
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 5),
                startPadding: 40.0,
                accelerationDuration: const Duration(seconds: 3),
                accelerationCurve: Curves.easeIn,
                decelerationDuration: const Duration(milliseconds: 1000),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.story.author ?? 'نویسنده ناشناس',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.comment),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: () {
                  // TODO: Implement comments functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.playlist_play),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: () {
                  _showPlaylist(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.download),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: () {
                  // TODO: Implement download functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: () {
                  // TODO: Implement like functionality
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: currentPosition.inSeconds.toDouble(),
            max: totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              _seekAudio(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.orange,
            inactiveColor: isDarkMode ? Colors.white38 : Colors.black38,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                "${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                color: isDarkMode ? Colors.white : Colors.black,
                iconSize: 36,
                onPressed: _rewindAudio,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: IconButton(
                  key: ValueKey<bool>(isPlaying),
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  color: isDarkMode ? Colors.white : Colors.black,
                  iconSize: 48,
                  onPressed: _playPauseAudio,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.forward_30),
                color: isDarkMode ? Colors.white : Colors.black,
                iconSize: 36,
                onPressed: _forwardAudio,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _showPlaylist(BuildContext context) {
    // Mock API call for playlist
    final List<String> playlist = []; // Replace with API call

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        if (playlist.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'لیست پخش خالی است',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                playlist[index],
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                // TODO: Handle playlist item click
              },
            );
          },
        );
      },
    );
  }
}
