import 'package:get/get.dart';

enum KycStep { credentials, aadhaar, liveness }

class TrustedShieldController extends GetxController {
  // State
  final isSubmitting = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isSubmitted = false.obs;

  // Business Credentials
  final businessName = ''.obs;
  final gstNumber = ''.obs;
  final panNumber = ''.obs;
  final gstFileName = ''.obs;
  final firmCardFileName = ''.obs;

  // Aadhaar Verification
  final aadhaarNumber = ''.obs;
  final aadhaarFrontFileName = ''.obs;
  final aadhaarBackFileName = ''.obs;

  // Liveness Check
  final isScanning = false.obs;
  final isFaceDetected = false.obs;
  final scanProgress = 0.0.obs;

  // ── helpers for UI: which step cards are "expanded" ──
  final expandedStep = Rx<KycStep>(KycStep.credentials);

  void setExpanded(KycStep step) => expandedStep.value = step;

  // ── Field setters ──
  void onBusinessNameChanged(String v) => businessName.value = v;
  void onGstNumberChanged(String v) => gstNumber.value = v;
  void onPanNumberChanged(String v) => panNumber.value = v;
  void onAadhaarNumberChanged(String v) => aadhaarNumber.value = v;

  // Simulate file picker
  void pickGstCertificate() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    gstFileName.value = 'GST_Certificate_2024.pdf';
  }

  void pickFirmCard() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    firmCardFileName.value = 'Firm_Card_Copy.jpg';
  }

  void pickAadhaarFront() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    aadhaarFrontFileName.value = 'Aadhaar_Front.jpg';
  }

  void pickAadhaarBack() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    aadhaarBackFileName.value = 'Aadhaar_Back.jpg';
  }

  // Simulate liveness scanning
  Future<void> startScan() async {
    if (isScanning.value) return;
    isScanning.value = true;
    isFaceDetected.value = false;
    scanProgress.value = 0.0;

    try {
      // Simulate step-by-step scan progress
      for (int i = 1; i <= 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 280));
        scanProgress.value = i / 10;
        if (i == 6) isFaceDetected.value = true;
      }
    } finally {
      isScanning.value = false;
    }
  }

  // Final submission
  Future<void> submitAll() async {
    isSubmitting.value = true;
    hasError.value = false;

    try {
      // Simulate API delay
      await Future<void>.delayed(const Duration(seconds: 2));

      // Validation
      if (businessName.value.trim().isEmpty) {
        throw Exception('Business name is required');
      }
      if (aadhaarNumber.value.length != 12) {
        throw Exception('Aadhaar number must be 12 digits');
      }

      isSubmitted.value = true;
      Get.snackbar(
        'Submitted!',
        'Your KYC details have been submitted for review.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
