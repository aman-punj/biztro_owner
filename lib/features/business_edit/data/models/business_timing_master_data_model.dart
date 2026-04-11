import 'package:bizrato_owner/features/business_edit/data/models/payment_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/time_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/week_model.dart';

class BusinessTimingMasterDataModel {
  const BusinessTimingMasterDataModel({
    required this.timeList,
    required this.weekList,
    required this.paymentList,
  });

  factory BusinessTimingMasterDataModel.fromJson(Map<String, dynamic> json) {
    final result = _extractMap(json['Result']);
    return BusinessTimingMasterDataModel(
      timeList: _extractList(result['Times'])
          .map(TimeModel.fromJson)
          .where((item) => item.id > 0 && item.value.isNotEmpty)
          .toList(),
      weekList: _extractList(result['Weeks'])
          .map(WeekModel.fromJson)
          .where((item) => item.id > 0 && item.name.isNotEmpty)
          .toList(),
      paymentList: _extractList(result['Payments'])
          .map(PaymentModel.fromJson)
          .where((item) => item.id > 0)
          .toList(),
    );
  }

  final List<TimeModel> timeList;
  final List<WeekModel> weekList;
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
}
