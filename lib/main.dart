import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikkkk/view/tiktok_home_view.dart';
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





