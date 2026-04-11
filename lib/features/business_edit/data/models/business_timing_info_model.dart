import 'package:bizrato_owner/features/business_edit/data/models/day_timing_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/payment_model.dart';

class BusinessTimingInfoModel {
  const BusinessTimingInfoModel({
    required this.merchantId,
    required this.isDisplayHoursOfOperation,
    required this.timeTableList,
    required this.paymentList,
  });

  factory BusinessTimingInfoModel.fromJson(Map<String, dynamic> json) {
    final result = _extractMap(json['Result']);
    return BusinessTimingInfoModel(
      merchantId: _readInt(result['MerchantId']),
      isDisplayHoursOfOperation:
          _readBool(result['IsDisplayHoursOfOperation']),
      timeTableList: _extractList(result['TimeTableList'])
          .map(DayTimingModel.fromJson)
          .where((item) => item.weekId > 0)
          .toList(),
      paymentList: _extractList(result['PaymentList'])
          .map(PaymentModel.fromJson)
          .where((item) => item.id > 0)
          .toList(),
    );
  }

  final int merchantId;
  final bool isDisplayHoursOfOperation;
  final List<DayTimingModel> timeTableList;
  final List<PaymentModel> paymentList;

  static Map<String, dynamic> _extractMap(dynamic value) {
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _extractList(dynamic value) {
    if (value is List) {
      return value.whereType<Map>().map((item) => item.cast<String, dynamic>()).toList();
    }
    return const <Map<String, dynamic>>[];
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _readBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final normalized = value?.toString().trim().toLowerCase() ?? '';
    return normalized == 'true' || normalized == '1';
  }
}
