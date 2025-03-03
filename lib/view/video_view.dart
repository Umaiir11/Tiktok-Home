import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import '../view_model/tiktok_home_controller.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  bool _showPlayPause = false;
  bool _isPlaying = true;

  final TikTokController _controller = Get.find<TikTokController>();

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _isPlaying = true;
      });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _showPlayPause = true;
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _isPlaying = false;
      } else {
        _videoController.play();
        _isPlaying = true;
      }
      _animationController.forward(from: 0);
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _showPlayPause = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _controller.addHeart(details.globalPosition);
      },
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _videoController.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: _videoController.value.size.aspectRatio > 1
                  ? BoxFit.contain
                  : BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          )
              : Center(child: CircularProgressIndicator()),
          AnimatedOpacity(
            opacity: _showPlayPause ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.white.withOpacity(0.8),
              size: 100,
            ),
          ),
          Obx(() {
            return Stack(
              children: _controller.hearts
                  .map((heart) => Positioned(
                left: heart.position.dx - 15,
                top: heart.position.dy - 15,
                child: heart.build(),
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}