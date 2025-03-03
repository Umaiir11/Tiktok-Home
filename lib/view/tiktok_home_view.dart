import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tikkkk/view/video_view.dart';

import '../main.dart';
import '../view_model/tiktok_home_controller.dart';

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
