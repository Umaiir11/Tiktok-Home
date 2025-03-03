import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Heart {
  final Offset position;
  final RxDouble opacity = 1.0.obs;
  final RxDouble yOffset = 0.0.obs;

  Heart({required this.position}) {
    _animate();
  }

  void _animate() async {
    for (double i = 0; i < 1; i += 0.02) {
      await Future.delayed(Duration(milliseconds: 16));
      yOffset.value -= 3;
      opacity.value -= 0.02;
    }
  }

  Widget build() {
    return Obx(() => AnimatedContainer(
      duration: Duration(milliseconds: 500),
      transform: Matrix4.translationValues(0, yOffset.value, 0),
      child: Opacity(
        opacity: opacity.value.clamp(0, 1),
        child: Icon(Icons.favorite, color: Colors.red, size: 50),
      ),
    ));
  }
}
