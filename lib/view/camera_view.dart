import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../view_model/camera_controller.dart';

class CameraUI extends StatelessWidget {
  final TikCameraController _cameraController = Get.put(TikCameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!_cameraController.isInitialized.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Camera preview or video preview
            Positioned.fill(
              child: _cameraController.isPreviewMode.value
                  ? _buildVideoPreview()
                  : _buildCameraPreview(),
            ),

            // Top music bar
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_cameraController.isPreviewMode.value) {
                        _cameraController.cancelPreview();
                      } else {
                        Get.back();
                      }
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
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

            // Timer countdown display
            if (_cameraController.countdownTimer != null && _cameraController.countdownTimer!.isActive)
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '${_cameraController.timerSeconds.value}',
                    style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // Right-side controls (only show when not in preview mode)
            if (!_cameraController.isPreviewMode.value)
              Positioned(
                right: 16,
                top: 120,
                child: Column(
                  children: [
                    _buildIconButton(Icons.speed, 'Speed'),
                    _buildIconButton(Icons.filter, 'Filters'),
                    _buildTimerButton(),
                    _buildFlashButton(),
                    _buildFlipButton(),
                  ],
                ),
              ),

            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _cameraController.isPreviewMode.value
                  ? _buildPreviewControls()
                  : _buildRecordingControls(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraController.cameraController != null && _cameraController.cameraController!.value.isInitialized) {
      final size = MediaQuery.of(Get.context!).size;

      // Calculate the size of the preview to maintain aspect ratio and fill the screen height
      final scale = 1 / (_cameraController.cameraController!.value.aspectRatio * size.aspectRatio);

      return Container(
        color: Colors.black,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: Center(
            child: CameraPreview(_cameraController.cameraController!),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildVideoPreview() {
    if (_cameraController.videoPlayerController == null ||
        !_cameraController.videoPlayerController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(Get.context!).size;
    final videoRatio = _cameraController.videoPlayerController!.value.aspectRatio;

    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: videoRatio,
          child: VideoPlayer(_cameraController.videoPlayerController!),
        ),
      ),
    );
  }

  Widget _buildTimerButton() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Container(
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('No Timer', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _cameraController.setTimer(0);
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('3 Seconds', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _cameraController.setTimer(3);
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('5 Seconds', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _cameraController.setTimer(5);
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('10 Seconds', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _cameraController.setTimer(10);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: _buildIconButton(
          Icons.timer,
          'Timer ${_cameraController.timerSeconds.value > 0 ? _cameraController.timerSeconds.value : "Off"}'
      ),
    );
  }

  Widget _buildFlashButton() {
    return Obx(() => _buildIconButton(
        _cameraController.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
        'Flash',
        onTap: _cameraController.toggleFlash
    ));
  }

  Widget _buildFlipButton() {
    return _buildIconButton(
        Icons.flip_camera_ios,
        'Flip',
        onTap: _cameraController.toggleCamera
    );
  }

  Widget _buildRecordingControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(Icons.auto_awesome, 'Effects'),
            SizedBox(width: 80),
            GestureDetector(
              onTap: () {
                if (_cameraController.isRecording.value) {
                  _cameraController.stopRecording();
                } else {
                  _cameraController.startRecording();
                }
              },
              child: Obx(() => CircleAvatar(
                radius: 35,
                backgroundColor: Colors.red,
                child: Icon(
                  _cameraController.isRecording.value
                      ? Icons.stop
                      : Icons.fiber_manual_record,
                  color: Colors.white,
                  size: 40,
                ),
              )),
            ),
            SizedBox(width: 80),
            _buildIconButton(Icons.image, 'Gallery'),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(Icons.close, 'Discard', onTap: _cameraController.cancelPreview),
        GestureDetector(
          onTap: () {
            if (_cameraController.videoPlayerController?.value.isPlaying ?? false) {
              _cameraController.videoPlayerController?.pause();
            } else {
              _cameraController.videoPlayerController?.play();
            }
          },
          child: _buildIconButton(
              _cameraController.videoPlayerController?.value.isPlaying ?? false
                  ? Icons.pause
                  : Icons.play_arrow,
              'Play/Pause'
          ),
        ),
        _buildIconButton(Icons.upload, 'Upload', onTap: _cameraController.uploadVideo),
      ],
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