import 'dart:io';

import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class LiveIdentityVerificationController extends GetxController {
  final RxBool isInitializing = true.obs;
  final RxBool isCapturing = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<CameraController> cameraController = Rxn<CameraController>();

  AppToastService get _toastService => Get.find<AppToastService>();

  bool get isReady =>
      !isInitializing.value &&
      errorMessage.value.isEmpty &&
      cameraController.value?.value.isInitialized == true;

  double get previewAspectRatio =>
      cameraController.value?.value.aspectRatio ?? 1;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    isInitializing.value = true;
    errorMessage.value = '';

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        errorMessage.value = 'Camera is unavailable on this device.';
        return;
      }

      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      cameraController.value?.dispose();
      cameraController.value = controller;
    } on CameraException catch (error) {
      errorMessage.value = _mapCameraError(error);
    } catch (_) {
      errorMessage.value = 'Unable to start live verification camera.';
    } finally {
      isInitializing.value = false;
    }
  }

  Future<void> captureImage() async {
    final controller = cameraController.value;
    if (controller == null || !controller.value.isInitialized) {
      _toastService.error('Camera is not ready yet.');
      return;
    }

    if (isCapturing.value) {
      return;
    }

    isCapturing.value = true;
    try {
      final capturedFile = await controller.takePicture();
      final tempDirectory = await getTemporaryDirectory();
      final savedPath =
          '${tempDirectory.path}/bizrato_live_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(capturedFile.path).copy(savedPath);
      Get.back<String>(result: savedPath);
    } on CameraException catch (error) {
      _toastService.error(_mapCameraError(error),);
    } catch (_) {
      _toastService.error('Unable to capture image right now.');
    } finally {
      isCapturing.value = false;
    }
  }

  Future<void> retryInitialization() async {
    await cameraController.value?.dispose();
    cameraController.value = null;
    await _initializeCamera();
  }

  String _mapCameraError(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
      case 'cameraPermission':
        return 'Camera permission is required for live identity verification.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      case 'AudioAccessDenied':
        return 'Unable to access camera resources right now.';
      default:
        return 'Unable to start live verification camera.';
    }
  }
}
