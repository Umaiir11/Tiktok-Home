import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../view/camera_view.dart';
import '../widgets/heart_widget.dart';

class TikTokController extends GetxController {
  final PageController pageController = PageController();
  final RxInt selectedIndex = 0.obs;
  final List<String> videoUrls = [
    'https://videos.pexels.com/video-files/5648482/5648482-uhd_2732_1440_25fps.mp4',
    'https://videos.pexels.com/video-files/5659595/5659595-uhd_1440_2732_25fps.mp4',
    'https://videos.pexels.com/video-files/30835589/13190162_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/11038949/11038949-hd_1920_1080_24fps.mp4',
  ];

  void changeTab(int index) async {
    if (index == 2) {
      // Open camera when Add button is tapped
      Get.to(() => CameraUI());    } else {
      selectedIndex.value = index;
    }
  }

  final RxList<Heart> hearts = <Heart>[].obs;

  void addHeart(Offset position) {
    final heart = Heart(position: position);
    hearts.add(heart);

    Future.delayed(Duration(milliseconds: 800), () {
      hearts.remove(heart);
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
