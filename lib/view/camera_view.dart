import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/camera_controller.dart';

class CameraUI extends StatelessWidget {
  final CameraController _cameraController = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera preview placeholder
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Center(child: Text('Camera Preview', style: TextStyle(color: Colors.white))
              ),
            ),
          ),

          // Top music bar
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back, color: Colors.white),
                Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Lorem Ipsum', style: TextStyle(color: Colors.white))
                  ],
                ),
                Icon(Icons.wifi, color: Colors.white),
              ],
            ),
          ),

          // Right-side controls
          Positioned(
            right: 16,
            top: 120,
            child: Column(
              children: [
                _buildIconButton(Icons.speed, 'Speed'),
                _buildIconButton(Icons.filter, 'Filters'),
                _buildIconButton(Icons.timer, 'Timer'),
                Obx(() => _buildIconButton(
                    _cameraController.isFlashOn.value ? Icons.flash_on : Icons.flash_off, 'Flash',
                    onTap: _cameraController.toggleFlash)),
                _buildIconButton(Icons.flip_camera_ios, 'Flip', onTap: _cameraController.toggleCamera),
              ],
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(Icons.auto_awesome, 'Effects'),
                    SizedBox(width: 80),
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.fiber_manual_record, color: Colors.white, size: 40),
                      ),
                    ),
                    SizedBox(width: 80),
                    _buildIconButton(Icons.upload, 'Upload'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, {VoidCallback? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.black54,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12))
      ],
    );
  }
}
