import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TikTok Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: TikTokHomeScreen(),
    );
  }
}

class TikTokHomeScreen extends StatelessWidget {
  final TikTokController _controller = Get.put(TikTokController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller.pageController,
            scrollDirection: Axis.vertical,
            itemCount: _controller.videoUrls.length,
            itemBuilder: (context, index) {
              return VideoPlayerWidget(videoUrl: _controller.videoUrls[index]);
            },
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _controller.changeTab(0),
                  child: Obx(() => Text(
                    'Following',
                    style: TextStyle(
                      color: _controller.selectedIndex.value == 0
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
                GestureDetector(
                  onTap: () => _controller.changeTab(1),
                  child: Obx(() => Text(
                    'For You',
                    style: TextStyle(
                      color: _controller.selectedIndex.value == 1
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 100,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.comment, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _controller.selectedIndex.value,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _controller.changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
      )),
    );
  }
}

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
          Positioned(
            bottom: 100,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@Username',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Caption goes here...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Song Name - Artist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TikTokController extends GetxController {
  final PageController pageController = PageController();
  final RxInt selectedIndex = 0.obs;
  final List<String> videoUrls = [
    'https://videos.pexels.com/video-files/5648482/5648482-uhd_2732_1440_25fps.mp4',
    'https://videos.pexels.com/video-files/5659595/5659595-uhd_1440_2732_25fps.mp4',
    'https://videos.pexels.com/video-files/30835589/13190162_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/11038949/11038949-hd_1920_1080_24fps.mp4',
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
