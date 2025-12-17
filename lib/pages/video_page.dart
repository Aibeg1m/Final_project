import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../data/sport_videos.dart';

class VideoPage extends StatefulWidget {
  final Set<String> selectedSports;

  const VideoPage({super.key, required this.selectedSports});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController? _controller;
  String? playingVideoId;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void playVideo(String videoId) {
    _controller?.dispose();

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );

    setState(() {
      playingVideoId = videoId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSections = sportVideos.entries
        .where((e) => widget.selectedSports.contains(e.key))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sports Videos",
          style: TextStyle(color: Color(0xFFE6EAF0)),
        ),
        backgroundColor: Color(0xFF163B63),
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF163B63)),
          ListView(
            children: filteredSections.map((section) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        section.key,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE6EAF0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        children: section.value.map((videoId) {
                          final isPlaying = playingVideoId == videoId;

                          return Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: isPlaying && _controller != null
                                  ? YoutubePlayer(
                                controller: _controller!,
                                showVideoProgressIndicator: true,
                              )
                                  : GestureDetector(
                                onTap: () => playVideo(videoId),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        "https://img.youtube.com/vi/$videoId/hqdefault.jpg",
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      )
    );
  }
}
