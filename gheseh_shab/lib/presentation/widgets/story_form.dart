import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:just_audio/just_audio.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  const StoryCard({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: 'https://qesseyeshab.ir${story.image}',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDurationTag(),
                _buildPlayButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildPlayButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _showStoryPlayer(context);
      },
      borderRadius: BorderRadius.circular(50),
      child: const Icon(
        Icons.play_circle_fill,
        color: Colors.blueAccent,
        size: 40,
      ),
    );
  }

  void _showStoryPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return StoryPlayer(
              story: story,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }
}

class StoryPlayer extends StatefulWidget {
  final StoryModel story;
  final ScrollController scrollController;

  const StoryPlayer({
    Key? key,
    required this.story,
    required this.scrollController,
  }) : super(key: key);

  @override
  _StoryPlayerState createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudioPlayer();
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
    });
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      await _audioPlayer
          .setUrl('https://qesseyeshab.ir${widget.story.sampleAudio}');
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Hero(
      tag: 'storyPlayerHero',
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildDragIndicator(context),
              const SizedBox(height: 16),
              _buildStoryTitle(context),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: widget.scrollController,
                  children: [
                    _buildStoryImage(),
                    const SizedBox(height: 16),
                    _buildStoryDescription(context),
                    const SizedBox(height: 16),
                    _buildAudioControls(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragIndicator(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildStoryTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        widget.story.name ?? 'داستان ناشناخته',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1?.color,
          fontFamily: 'dana',
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: 'https://qesseyeshab.ir${widget.story.image}',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildStoryDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "توضیحات داستان: ${widget.story.info}",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyText2?.color,
          fontFamily: 'dana',
        ),
      ),
    );
  }

  Widget _buildAudioControls(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          StreamBuilder<Duration?>(
            stream: _audioPlayer.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  return Column(
                    children: [
                      Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (newValue) {
                          _audioPlayer
                              .seek(Duration(seconds: newValue.toInt()));
                        },
                        activeColor:
                            isDarkMode ? Colors.blueAccent : Colors.deepPurple,
                        inactiveColor:
                            isDarkMode ? Colors.grey[600] : Colors.grey[300],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color,
                              fontFamily: 'dana',
                            ),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color,
                              fontFamily: 'dana',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing ?? false;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10,
                          size: 32, color: Colors.white),
                      onPressed: () => _audioPlayer.seek(
                        _audioPlayer.position - const Duration(seconds: 10),
                      ),
                    ),
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering)
                      const CircularProgressIndicator()
                    else if (playing)
                      IconButton(
                        icon: const Icon(Icons.pause_circle_filled, size: 48),
                        color:
                            isDarkMode ? Colors.blueAccent : Colors.deepPurple,
                        onPressed: _audioPlayer.pause,
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.play_circle_filled, size: 48),
                        color:
                            isDarkMode ? Colors.blueAccent : Colors.deepPurple,
                        onPressed: _audioPlayer.play,
                      ),
                    IconButton(
                      icon: const Icon(Icons.forward_10,
                          size: 32, color: Colors.white),
                      onPressed: () => _audioPlayer.seek(
                        _audioPlayer.position + const Duration(seconds: 10),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
