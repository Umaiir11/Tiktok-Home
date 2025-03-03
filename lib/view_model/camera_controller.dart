import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:async';
import 'package:video_player/video_player.dart';

class TikCameraController extends GetxController {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  RxBool isFlashOn = false.obs;
  RxBool isFrontCamera = false.obs;
  RxInt timerSeconds = 0.obs;
  RxBool isRecording = false.obs;
  RxBool isInitialized = false.obs;
  RxString recordingPath = ''.obs;
  RxBool isPreviewMode = false.obs;
  Timer? countdownTimer;
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar('Error', 'No cameras found');
        return;
      }
      await _initCameraController(cameras[0]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    // Dispose old controller properly
    if (cameraController != null) {
      // First, set initialized to false to prevent UI updates during transition
      isInitialized.value = false;

      // Check if recording and stop if needed
      if (isRecording.value) {
        try {
          await stopRecording();
        } catch (e) {
          print('Error stopping recording during camera switch: $e');
        }
      }

      // Properly dispose the old controller
      await cameraController!.dispose();
      cameraController = null;
    }

    // Create and initialize new controller
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      // Wait for controller to initialize
      await cameraController!.initialize();
      isInitialized.value = true;
      await updateFlashMode();
    } catch (e) {
      Get.snackbar('Error', 'Camera initialization failed: $e');
    }
  }

  Future<void> toggleFlash() async {
    isFlashOn.value = !isFlashOn.value;
    await updateFlashMode();
  }

  Future<void> updateFlashMode() async {
    if (!isInitialized.value || cameraController == null) return;

    try {
      await cameraController!.setFlashMode(
          isFlashOn.value ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      Get.snackbar('Error', 'Flash mode change failed: $e');
    }
  }

  Future<void> toggleCamera() async {
    if (cameras.length < 2) {
      Get.snackbar('Error', 'Device has only one camera');
      return;
    }

    // Toggle the camera flag
    isFrontCamera.value = !isFrontCamera.value;

    // Select the new camera index
    int newIndex = isFrontCamera.value ? 1 : 0;

    // Show loading indicator while switching
    isInitialized.value = false;

    // Initialize the new camera
    await _initCameraController(cameras[newIndex]);
  }

  void setTimer(int seconds) {
    timerSeconds.value = seconds;
  }

  Future<void> startRecording() async {
    if (!isInitialized.value || cameraController == null) return;

    if (timerSeconds.value > 0) {
      int remainingSeconds = timerSeconds.value;
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        remainingSeconds--;
        if (remainingSeconds <= 0) {
          timer.cancel();
          _recordVideo();
        }
      });
    } else {
      await _recordVideo();
    }
  }

  Future<void> _recordVideo() async {
    if (!isInitialized.value || cameraController == null) return;

    try {
      await cameraController!.startVideoRecording();
      isRecording.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to start recording: $e');
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value || cameraController == null) return;

    try {
      XFile videoFile = await cameraController!.stopVideoRecording();
      isRecording.value = false;
      recordingPath.value = videoFile.path;

      // Clean up any existing player
      await videoPlayerController?.dispose();

      // Create and initialize the video player
      videoPlayerController = VideoPlayerController.file(File(videoFile.path));
      await videoPlayerController!.initialize();

      if (videoPlayerController!.value.isInitialized) {
        videoPlayerController!.setLooping(true);
        await videoPlayerController!.play();
        isPreviewMode.value = true;
      } else {
        Get.snackbar('Error', 'Failed to initialize video player');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop recording: $e');
    }
  }

  void cancelPreview() {
    if (videoPlayerController != null) {
      videoPlayerController!.pause();
      videoPlayerController!.dispose();
      videoPlayerController = null;
    }
    isPreviewMode.value = false;
  }

  void uploadVideo() {
    if (recordingPath.value.isEmpty) return;

    Get.snackbar('Upload', 'Video upload started...');
    // Reset preview state
    cancelPreview();
    // TODO: Add your actual upload logic here
  }

  @override
  void onClose() {
    // Make sure to dispose all resources
    countdownTimer?.cancel();
    videoPlayerController?.dispose();
    if (isRecording.value && cameraController != null) {
      cameraController!.stopVideoRecording();
    }
    cameraController?.dispose();
    super.onClose();
  }
}