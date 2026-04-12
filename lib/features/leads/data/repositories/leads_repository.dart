import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/leads/data/models/lead_model.dart';

class LeadsRepository {
  LeadsRepository(this._apiClient, this._authStorage);

  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  Future<AppResponse<List<LeadModel>>> getLeads() async {
    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId <= 0) {
      return AppResponse.failure(message: 'Invalid Merchant ID');
    }

    final response = await _apiClient.get(
      '/api/leads/allleads',
      queryParameters: {'MerchantId': merchantId},
    );

    if (response.success) {
      try {
        final List<dynamic>? data = response.data?['Result'];
        if (data != null) {
          final leads = data
              .map((json) => LeadModel.fromJson(json as Map<String, dynamic>))
              .toList();
          return AppResponse(
            success: true,
            data: leads,
            message: response.message,
            statusCode: response.statusCode,
          );
        }
        return AppResponse(
          success: true,
          data: <LeadModel>[],
          message: response.message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return AppResponse.failure(
          message: 'Failed to parse leads: $e',
          statusCode: response.statusCode,
        );
      }
    }

    return AppResponse.failure(
      message: response.message,
      statusCode: response.statusCode,
    );
  }
}
