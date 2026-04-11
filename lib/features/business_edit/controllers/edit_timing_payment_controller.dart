import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/widgets/app_status_dialog.dart';
import 'package:bizrato_owner/features/business_edit/data/models/business_timing_info_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/business_timing_master_data_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/day_timing_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/payment_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/save_business_timing_request.dart';
import 'package:bizrato_owner/features/business_edit/data/models/time_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/week_model.dart';
import 'package:bizrato_owner/features/business_edit/data/repositories/business_timing_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class EditTimingPaymentController extends GetxController {
  EditTimingPaymentController({required this.repository});

  final BusinessTimingRepository repository;
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final AppToastService _toastService = Get.find<AppToastService>();

  final RxBool isLoadingPage = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDisplayHours = true.obs;

  final RxList<TimeModel> timeList = <TimeModel>[].obs;
  final RxList<WeekModel> weekList = <WeekModel>[].obs;
  final RxList<PaymentModel> paymentList = <PaymentModel>[].obs;
  final RxList<DayTimingModel> dayTimings = <DayTimingModel>[].obs;

  int? get open24HoursId => _findTimeId('Open 24 Hrs');
  int? get closedTimeId => _findTimeId('Closed');

  bool get areAllPaymentsSelected =>
      paymentList.isNotEmpty && paymentList.every((item) => item.isSelected);

  @override
  void onInit() {
    super.onInit();
    loadPage();
  }

  Future<void> loadPage() async {
    isLoadingPage.value = true;
    try {
      final merchantId = _authStorage.merchantId;
      if (merchantId == null || merchantId == 0) {
        _toastService.error('Merchant ID is not available.');
        return;
      }

      final AppResponse<BusinessTimingMasterDataModel> masterResponse =
          await repository.getMasterData();
      if (!masterResponse.success || masterResponse.data == null) {
        _toastService.error(
          masterResponse.message.isNotEmpty
              ? masterResponse.message
              : 'Unable to load timing master data.',
        );
        return;
      }

      _applyMasterData(masterResponse.data!);

      final AppResponse<BusinessTimingInfoModel?> timingResponse =
          await repository.getTimingInfo(merchantId);
      if (!timingResponse.success) {
        _toastService.error(
          timingResponse.message.isNotEmpty
              ? timingResponse.message
              : 'Unable to load business timing details.',
        );
        _buildDefaultDayTimings();
        return;
      }

      _applyExistingData(timingResponse.data);
    } finally {
      isLoadingPage.value = false;
    }
  }

  void _applyMasterData(BusinessTimingMasterDataModel masterData) {
    timeList.assignAll(masterData.timeList);
    weekList.assignAll(
      List<WeekModel>.from(masterData.weekList)
        ..sort((first, second) => first.id.compareTo(second.id)),
    );
    paymentList.assignAll(masterData.paymentList);
  }

  void _applyExistingData(BusinessTimingInfoModel? timingInfo) {
    if (timingInfo == null) {
      _buildDefaultDayTimings();
      return;
    }

    isDisplayHours.value = timingInfo.isDisplayHoursOfOperation;
    _buildDayTimingsFromExisting(timingInfo.timeTableList);
    _applySelectedPayments(timingInfo.paymentList);
  }

  void _buildDefaultDayTimings() {
    dayTimings.assignAll(
      weekList
          .map(
            (week) => DayTimingModel(
              weekId: week.id,
              fromTimeId: null,
              toTimeId: null,
              isClosed: false,
            ),
          )
          .toList(),
    );
  }

  void _buildDayTimingsFromExisting(List<DayTimingModel> savedTimings) {
    final Map<int, DayTimingModel> timingByWeek = <int, DayTimingModel>{};
    for (final dayTiming in savedTimings) {
      timingByWeek[dayTiming.weekId] = _sanitizeDayTiming(dayTiming);
    }

    dayTimings.assignAll(
      weekList
          .map(
            (week) => timingByWeek[week.id] ??
                DayTimingModel(
                  weekId: week.id,
                  fromTimeId: null,
                  toTimeId: null,
                  isClosed: false,
                ),
          )
          .toList(),
    );
  }

  DayTimingModel _sanitizeDayTiming(DayTimingModel timing) {
    if (timing.isClosed) {
      return timing.copyWith(
        isClosed: true,
        clearFromTime: true,
        clearToTime: true,
      );
    }

    final hasValidFrom =
        timing.fromTimeId != null && _hasTimeId(timing.fromTimeId!);
    final hasValidTo = timing.toTimeId != null && _hasTimeId(timing.toTimeId!);

    return DayTimingModel(
      weekId: timing.weekId,
      fromTimeId: hasValidFrom ? timing.fromTimeId : null,
      toTimeId: hasValidTo ? timing.toTimeId : null,
      isClosed: false,
    );
  }

  void _applySelectedPayments(List<PaymentModel> selectedPayments) {
    final Map<int, bool> selectionById = <int, bool>{};
    for (final payment in selectedPayments) {
      selectionById[payment.id] = payment.isSelected;
    }

    paymentList.assignAll(
      paymentList
          .map(
            (payment) => payment.copyWith(
              isSelected: selectionById[payment.id] ?? false,
            ),
          )
          .toList(),
    );
  }

  void toggleDisplayHours(bool value) {
    isDisplayHours.value = value;
  }

  void togglePayment(int paymentMethodId) {
    final index = paymentList.indexWhere((item) => item.id == paymentMethodId);
    if (index == -1) {
      return;
    }

    final payment = paymentList[index];
    paymentList[index] = payment.copyWith(isSelected: !payment.isSelected);
    paymentList.refresh();
  }

  void toggleAllPayments(bool shouldSelectAll) {
    paymentList.assignAll(
      paymentList
          .map((payment) => payment.copyWith(isSelected: shouldSelectAll))
          .toList(),
    );
  }

  void updateFromTime(int weekId, int selectedTimeId) {
    _updateDayTiming(
      weekId: weekId,
      selectedTimeId: selectedTimeId,
      isFromTime: true,
    );
  }

  void updateToTime(int weekId, int selectedTimeId) {
    _updateDayTiming(
      weekId: weekId,
      selectedTimeId: selectedTimeId,
      isFromTime: false,
    );
  }

  void _updateDayTiming({
    required int weekId,
    required int selectedTimeId,
    required bool isFromTime,
  }) {
    final index = dayTimings.indexWhere((item) => item.weekId == weekId);
    if (index == -1) {
      return;
    }

    final current = dayTimings[index];
    final int? closedId = closedTimeId;
    final int? allDayId = open24HoursId;

    if (closedId != null && selectedTimeId == closedId) {
      dayTimings[index] = current.copyWith(
        isClosed: true,
        clearFromTime: true,
        clearToTime: true,
      );
      dayTimings.refresh();
      return;
    }

    if (allDayId != null && selectedTimeId == allDayId) {
      dayTimings[index] = current.copyWith(
        fromTimeId: allDayId,
        toTimeId: allDayId,
        isClosed: false,
      );
      dayTimings.refresh();
      return;
    }

    final int? nextFrom = isFromTime ? selectedTimeId : current.fromTimeId;
    final int? nextTo = isFromTime ? current.toTimeId : selectedTimeId;

    dayTimings[index] = DayTimingModel(
      weekId: current.weekId,
      fromTimeId: nextFrom == allDayId ? null : nextFrom,
      toTimeId: nextTo == allDayId ? null : nextTo,
      isClosed: false,
    );
    dayTimings.refresh();
  }

  void copyMondayToAllDays() {
    final monday = dayTimings.firstWhereOrNull((item) => item.weekId == 1);
    if (monday == null) {
      _toastService.error('Monday timing is unavailable.');
      return;
    }

    dayTimings.assignAll(
      dayTimings
          .map(
            (item) => DayTimingModel(
              weekId: item.weekId,
              fromTimeId: monday.fromTimeId,
              toTimeId: monday.toTimeId,
              isClosed: monday.isClosed,
            ),
          )
          .toList(),
    );
  }

  String getWeekName(int weekId) {
    return weekList
            .firstWhereOrNull((week) => week.id == weekId)
            ?.name ??
        'Day';
  }

  String getFromTimeLabel(int weekId) {
    final dayTiming = dayTimings.firstWhereOrNull((item) => item.weekId == weekId);
    return _resolveTimeLabel(
      timeId: dayTiming?.fromTimeId,
      isClosed: dayTiming?.isClosed ?? false,
    );
  }

  String getToTimeLabel(int weekId) {
    final dayTiming = dayTimings.firstWhereOrNull((item) => item.weekId == weekId);
    return _resolveTimeLabel(
      timeId: dayTiming?.toTimeId,
      isClosed: dayTiming?.isClosed ?? false,
    );
  }

  String _resolveTimeLabel({
    required int? timeId,
    required bool isClosed,
  }) {
    if (isClosed) {
      return _timeLabelByName('Closed') ?? 'Closed';
    }

    if (timeId == null) {
      return 'Select Time';
    }

    return timeList
            .firstWhereOrNull((item) => item.id == timeId)
            ?.value ??
        'Select Time';
  }

  bool validateBeforeSave() {
    if (weekList.length != 7 || dayTimings.length != 7) {
      _toastService.error('All 7 days must be configured.');
      return false;
    }

    for (final dayTiming in dayTimings) {
      if (!dayTiming.isClosed &&
          (dayTiming.fromTimeId == null || dayTiming.toTimeId == null)) {
        _toastService.error(
          'Please select opening and closing times for ${getWeekName(dayTiming.weekId)}.',
        );
        return false;
      }
    }

    return true;
  }

  Future<void> saveAndUpdate() async {
    if (!validateBeforeSave()) {
      return;
    }

    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      _toastService.error('Merchant ID is unavailable.');
      return;
    }

    final request = SaveBusinessTimingRequest(
      merchantId: merchantId,
      isDisplayHoursOfOperation: isDisplayHours.value,
      timeTableList: _normalizedDayTimings(),
      paymentList: List<PaymentModel>.from(paymentList),
    );

    isSaving.value = true;
    try {
      final response = await repository.saveTimingInfo(request);
      if (!response.success) {
        await AppStatusDialog.show(
          dialog: AppStatusDialog.error(
            message: response.message.isNotEmpty
                ? response.message
                : 'Unable to update timing and payment information.',
          ),
        );
        return;
      }

      await AppStatusDialog.show(
        dialog: AppStatusDialog.success(
          message: 'Timing and payment information updated successfully.',
        ),
        onDismissed: () => Get.offAllNamed(AppRoutes.dashboard),
      );
    } finally {
      isSaving.value = false;
    }
  }

  List<DayTimingModel> _normalizedDayTimings() {
    return weekList
        .map(
          (week) => dayTimings.firstWhere(
            (item) => item.weekId == week.id,
            orElse: () => DayTimingModel(
              weekId: week.id,
              fromTimeId: null,
              toTimeId: null,
              isClosed: false,
            ),
          ),
        )
        .toList();
  }

  int? _findTimeId(String label) {
    final normalizedLabel = label.trim().toLowerCase();
    return timeList
        .firstWhereOrNull(
          (item) => item.value.trim().toLowerCase() == normalizedLabel,
        )
        ?.id;
  }

  String? _timeLabelByName(String label) {
    final normalizedLabel = label.trim().toLowerCase();
    return timeList
        .firstWhereOrNull(
          (item) => item.value.trim().toLowerCase() == normalizedLabel,
        )
        ?.value;
  }

  bool _hasTimeId(int id) {
    return timeList.any((item) => item.id == id);
  }
}
