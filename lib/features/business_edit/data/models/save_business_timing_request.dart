import 'package:bizrato_owner/features/business_edit/data/models/day_timing_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/payment_model.dart';

class SaveBusinessTimingRequest {
  const SaveBusinessTimingRequest({
    required this.merchantId,
    required this.isDisplayHoursOfOperation,
    required this.timeTableList,
    required this.paymentList,
  });

  final int merchantId;
  final bool isDisplayHoursOfOperation;
  final List<DayTimingModel> timeTableList;
  final List<PaymentModel> paymentList;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'MerchantId': merchantId,
      'IsDisplayHoursOfOperation': isDisplayHoursOfOperation,
      'TimeTableList': timeTableList.map((item) => item.toJson()).toList(),
      'PaymentList': paymentList
          .map(
            (item) => <String, dynamic>{
              'PaymentMethodId': item.id,
              'IsMethodSelected': item.isSelected,
            },
          )
          .toList(),
    };
  }
}
