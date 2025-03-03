import 'package:get/get.dart';

class CameraController extends GetxController {
  var isFlashOn = false.obs;
  var isFrontCamera = false.obs;
  var timerSeconds = 0.obs;

  void toggleFlash() {
    isFlashOn.value = !isFlashOn.value;
  }

  void toggleCamera() {
    isFrontCamera.value = !isFrontCamera.value;
  }

  void setTimer(int seconds) {
    timerSeconds.value = seconds;
  }
}