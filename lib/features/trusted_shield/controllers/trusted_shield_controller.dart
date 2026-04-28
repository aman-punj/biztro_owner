import 'dart:convert';
import 'dart:io';

import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/widgets/app_status_dialog.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/services/image_compression_service.dart';
import 'package:bizrato_owner/features/trusted_shield/data/models/trusted_shield_kyc_model.dart';
import 'package:bizrato_owner/features/trusted_shield/data/repositories/trusted_shield_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum KycStep { credentials, aadhaar, liveness }

enum KycDocumentType { gst, pan, aadhaarFront, aadhaarBack, live }

class TrustedShieldController extends GetxController {
  TrustedShieldController({
    required this.repository,
    required this.compressionService,
  });

  final TrustedShieldRepository repository;
  final ImageCompressionService compressionService;
  final AppToastService _toastService = Get.find<AppToastService>();
  final AuthStorage _authStorage = Get.find<AuthStorage>();

  final isLoading = true.obs;
  final isSubmitting = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final loaderMessage = ''.obs;
  final hasExistingKyc = false.obs;
  final hasNoData = false.obs;
  final emptyStateMessage = ''.obs;
  final kycStatus = RxnInt();
  final currentBizId = ''.obs;
  final adminRemarks = ''.obs;
  final formRevision = 0.obs;

  final firmNameController = TextEditingController();
  final gstNumberController = TextEditingController();
  final panNumberController = TextEditingController();
  final aadhaarNumberController = TextEditingController();

  final gstLocalPath = RxnString();
  final gstServerPath = RxnString();
  final gstFileName = ''.obs;

  final panLocalPath = RxnString();
  final panServerPath = RxnString();
  final panImageFileName = ''.obs;

  final aadhaarFrontLocalPath = RxnString();
  final aadhaarFrontServerPath = RxnString();
  final aadhaarFrontFileName = ''.obs;

  final aadhaarBackLocalPath = RxnString();
  final aadhaarBackServerPath = RxnString();
  final aadhaarBackFileName = ''.obs;

  final liveImageLocalPath = RxnString();
  final liveImageServerPath = RxnString();
  final liveImageFileName = ''.obs;

  final expandedStep = Rx<KycStep>(KycStep.credentials);

  bool get isBusy => isLoading.value || isSubmitting.value;

  bool get hasBusinessCredentialsCompleted {
    formRevision.value;
    return firmNameController.text.trim().isNotEmpty &&
        gstNumberController.text.trim().isNotEmpty &&
        panNumberController.text.trim().isNotEmpty &&
        _hasDocument(KycDocumentType.gst) &&
        _hasDocument(KycDocumentType.pan);
  }

  bool get hasAadhaarCompleted {
    formRevision.value;
    return aadhaarNumberController.text.trim().length == 12 &&
        _hasDocument(KycDocumentType.aadhaarFront) &&
        _hasDocument(KycDocumentType.aadhaarBack);
  }

  bool get hasLiveImageCompleted => _hasDocument(KycDocumentType.live);

  @override
  void onInit() {
    super.onInit();
    _listenToTextControllers();
    loadKycDetails();
  }

  @override
  void onClose() {
    firmNameController.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
    aadhaarNumberController.dispose();
    super.onClose();
  }

  void setExpanded(KycStep step) => expandedStep.value = step;

  Future<void> loadKycDetails({bool showLoader = true}) async {
    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      hasError.value = true;
      errorMessage.value = 'Merchant ID is unavailable.';
      isLoading.value = false;
      return;
    }

    if (showLoader) {
      isLoading.value = true;
      loaderMessage.value = 'Loading KYC details...';
    }

    hasError.value = false;
    emptyStateMessage.value = '';

    final response = await repository.getKycDetails(merchantId);
    if (!response.success) {
      hasError.value = true;
      errorMessage.value = response.message;
      isLoading.value = false;
      loaderMessage.value = '';
      return;
    }

    final model = response.data;
    if (model == null || !model.hasExistingData) {
      hasExistingKyc.value = false;
      hasNoData.value = true;
      emptyStateMessage.value = response.message.isNotEmpty
          ? response.message
          : 'No KYC details found. Fill in the form to continue.';
      _clearServerDocuments();
      currentBizId.value = '';
      kycStatus.value = null;
      adminRemarks.value = '';
      isLoading.value = false;
      loaderMessage.value = '';
      return;
    }

    _hydrateKyc(model);
    hasExistingKyc.value = true;
    hasNoData.value = false;
    emptyStateMessage.value = '';
    isLoading.value = false;
    loaderMessage.value = '';
  }

  Future<void> pickDocument(KycDocumentType type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions(type),
      allowMultiple: false,
    );

    final selectedPath = result?.files.single.path;
    if (selectedPath == null || selectedPath.isEmpty) {
      return;
    }

    final fileName = _extractFileName(selectedPath);
    switch (type) {
      case KycDocumentType.gst:
        gstLocalPath.value = selectedPath;
        gstFileName.value = fileName;
        break;
      case KycDocumentType.pan:
        panLocalPath.value = selectedPath;
        panImageFileName.value = fileName;
        break;
      case KycDocumentType.aadhaarFront:
        aadhaarFrontLocalPath.value = selectedPath;
        aadhaarFrontFileName.value = fileName;
        break;
      case KycDocumentType.aadhaarBack:
        aadhaarBackLocalPath.value = selectedPath;
        aadhaarBackFileName.value = fileName;
        break;
      case KycDocumentType.live:
        liveImageLocalPath.value = selectedPath;
        liveImageFileName.value = fileName;
        break;
    }

    formRevision.value++;
  }

  Future<void> _compressImagesIfNeeded() async {
    final docs = {
      'GST': (gstLocalPath, gstFileName),
      'PAN': (panLocalPath, panImageFileName),
      'Aadhaar Front': (aadhaarFrontLocalPath, aadhaarFrontFileName),
      'Aadhaar Back': (aadhaarBackLocalPath, aadhaarBackFileName),
    };

    for (var entry in docs.entries) {
      final pathRx = entry.value.$1;
      final nameRx = entry.value.$2;
      final path = pathRx.value;

      if (path != null && path.isNotEmpty && isImageFile(path)) {
        final file = File(path);
        if (await compressionService.isOverSize(file)) {
          loaderMessage.value =
              '${entry.key} image is more than 1MB. Compressing... Please do not press back or exit.';
          final compressedFile =
              await compressionService.compressIfNeeded(file);
          if (compressedFile != null) {
            pathRx.value = compressedFile.path;
            nameRx.value = _extractFileName(compressedFile.path);
            formRevision.value++;
          }
        }
      }
    }
  }

  Future<void> submitAll() async {
    final validationError = _validateForm();
    if (validationError != null) {
      _toastService.error(validationError);
      return;
    }

    final merchantId = _authStorage.merchantId;
    final bizId = _resolveBizId();
    if (merchantId == null || merchantId == 0 || bizId.isEmpty) {
      _toastService.error('Merchant details are unavailable.');
      return;
    }

    isSubmitting.value = true;
    hasError.value = false;

    await _compressImagesIfNeeded();

    loaderMessage.value = 'Saving KYC details...';

    final response = await repository.saveKyc(
      merchantId: merchantId.toString(),
      bizId: bizId,
      firmName: firmNameController.text.trim(),
      gstNumber: gstNumberController.text.trim(),
      panNumber: panNumberController.text.trim(),
      aadhaarNumber: aadhaarNumberController.text.trim(),
      gstImagePath: gstLocalPath.value,
      panImagePath: panLocalPath.value,
      aadhaarFrontImagePath: aadhaarFrontLocalPath.value,
      aadhaarBackImagePath: aadhaarBackLocalPath.value,
      liveImagePath: liveImageLocalPath.value,
      oldGstPath: gstServerPath.value,
      oldPanPath: panServerPath.value,
      oldAadharFrontPath: aadhaarFrontServerPath.value,
      oldAadharBackPath: aadhaarBackServerPath.value,
      oldLivePath: liveImageServerPath.value,
    );

    isSubmitting.value = false;
    loaderMessage.value = '';

    if (!response.success) {
      _toastService.error(response.message);
      return;
    }

    await AppStatusDialog.show(
      dialog: AppStatusDialog.success(
        message: response.message.isNotEmpty
            ? response.message
            : 'KYC details submitted successfully.',
      ),
      onDismissed: () => Get.offAllNamed(AppRoutes.dashboard),
    );
  }

  String buildImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }

    return repository.buildImageUrl(path);
  }

  Map<String, String>? buildImageHeaders() => null;

  Future<void> startLiveIdentityVerification() async {
    final result = await Get.toNamed(AppRoutes.liveIdentityVerification);
    if (result is! String || result.isEmpty) {
      return;
    }

    liveImageLocalPath.value = result;
    liveImageFileName.value = _extractFileName(result);
    formRevision.value++;
  }

  String localDocumentPath(KycDocumentType type) {
    switch (type) {
      case KycDocumentType.gst:
        return gstLocalPath.value ?? '';
      case KycDocumentType.pan:
        return panLocalPath.value ?? '';
      case KycDocumentType.aadhaarFront:
        return aadhaarFrontLocalPath.value ?? '';
      case KycDocumentType.aadhaarBack:
        return aadhaarBackLocalPath.value ?? '';
      case KycDocumentType.live:
        return liveImageLocalPath.value ?? '';
    }
  }

  String serverDocumentPath(KycDocumentType type) {
    switch (type) {
      case KycDocumentType.gst:
        return gstServerPath.value ?? '';
      case KycDocumentType.pan:
        return panServerPath.value ?? '';
      case KycDocumentType.aadhaarFront:
        return aadhaarFrontServerPath.value ?? '';
      case KycDocumentType.aadhaarBack:
        return aadhaarBackServerPath.value ?? '';
      case KycDocumentType.live:
        return liveImageServerPath.value ?? '';
    }
  }

  bool isImageFile(String path) {
    final extension = path.split('.').last.toLowerCase();
    return <String>['jpg', 'jpeg', 'png', 'webp'].contains(extension);
  }

  String statusLabel(int? status) {
    switch (status) {
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      case 3:
        return 'Resubmission Required';
      default:
        return 'Pending Review';
    }
  }

  Color statusColor(int? status) {
    switch (status) {
      case 1:
        return AppTokens.success;
      case 2:
        return AppTokens.error;
      case 3:
        return AppTokens.brandPrimaryDark;
      default:
        return AppTokens.info;
    }
  }

  void _listenToTextControllers() {
    firmNameController.addListener(_onFormChanged);
    gstNumberController.addListener(_onFormChanged);
    panNumberController.addListener(_onFormChanged);
    aadhaarNumberController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    formRevision.value++;
  }

  void _hydrateKyc(TrustedShieldKycModel model) {
    firmNameController.text = model.firmName;
    gstNumberController.text = model.gstNumber;
    panNumberController.text = model.panNumber;
    aadhaarNumberController.text = model.aadhaarNumber;

    gstServerPath.value = model.gstImagePath;
    panServerPath.value = model.panImagePath;
    aadhaarFrontServerPath.value = model.aadharFrontImagePath;
    aadhaarBackServerPath.value = model.aadhaarBackImagePath;
    liveImageServerPath.value = model.liveImagePath;
    currentBizId.value = model.bizId;

    gstFileName.value =
        _preferredDisplayName(gstLocalPath.value, model.gstImagePath);
    panImageFileName.value =
        _preferredDisplayName(panLocalPath.value, model.panImagePath);
    aadhaarFrontFileName.value = _preferredDisplayName(
      aadhaarFrontLocalPath.value,
      model.aadharFrontImagePath,
    );
    aadhaarBackFileName.value = _preferredDisplayName(
      aadhaarBackLocalPath.value,
      model.aadhaarBackImagePath,
    );
    liveImageFileName.value = _preferredDisplayName(
      liveImageLocalPath.value,
      model.liveImagePath,
    );

    kycStatus.value = model.kycStatus;
    adminRemarks.value = model.adminRemarks;
    formRevision.value++;
  }

  void _clearServerDocuments() {
    gstServerPath.value = null;
    panServerPath.value = null;
    aadhaarFrontServerPath.value = null;
    aadhaarBackServerPath.value = null;
    liveImageServerPath.value = null;
    formRevision.value++;
  }

  bool _hasDocument(KycDocumentType type) {
    return localDocumentPath(type).isNotEmpty ||
        serverDocumentPath(type).isNotEmpty;
  }

  String? _validateForm() {
    if (firmNameController.text.trim().isEmpty) {
      return 'Firm name is required.';
    }

    final gst = gstNumberController.text.trim();
    if (gst.isEmpty) {
      return 'GST number is required.';
    }
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(gst)) {
      return 'Invalid GST format.';
    }

    final pan = panNumberController.text.trim();
    if (pan.isEmpty) {
      return 'PAN number is required.';
    }
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(pan)) {
      return 'Invalid PAN format.';
    }

    final aadhaar = aadhaarNumberController.text.trim();
    if (!RegExp(r'^\d{12}$').hasMatch(aadhaar)) {
      return 'Aadhaar number must be exactly 12 digits.';
    }

    if (!_hasDocument(KycDocumentType.gst)) {
      return 'GST document is required.';
    }

    if (!_hasDocument(KycDocumentType.pan)) {
      return 'PAN document is required.';
    }

    if (!_hasDocument(KycDocumentType.aadhaarFront)) {
      return 'Aadhaar front image is required.';
    }

    if (!_hasDocument(KycDocumentType.aadhaarBack)) {
      return 'Aadhaar back image is required.';
    }

    if (!_hasDocument(KycDocumentType.live)) {
      return 'Live identity verification is required.';
    }

    return null;
  }

  List<String> _allowedExtensions(KycDocumentType type) {
    if (type == KycDocumentType.live) {
      return <String>['jpg', 'jpeg', 'png'];
    }

    return <String>['jpg', 'jpeg', 'png', 'pdf'];
  }

  String _resolveBizId() {
    final userJson = _authStorage.userJson;
    if (userJson == null || userJson.isEmpty) {
      return currentBizId.value;
    }

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic>) {
        return decoded['BusinessId']?.toString() ?? '';
      }
      if (decoded is Map) {
        return decoded['BusinessId']?.toString() ?? '';
      }
    } catch (_) {
      return currentBizId.value;
    }

    return currentBizId.value;
  }

  String _preferredDisplayName(String? localPath, String serverPath) {
    if (localPath != null && localPath.isNotEmpty) {
      return _extractFileName(localPath);
    }

    return _extractFileName(serverPath);
  }

  String _extractFileName(String path) {
    if (path.isEmpty) {
      return '';
    }

    final segments = File(path).uri.pathSegments;
    if (segments.isNotEmpty) {
      return segments.last;
    }

    return path.split('/').last;
  }
}
