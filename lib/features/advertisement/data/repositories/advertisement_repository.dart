import 'dart:io';

import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_category_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_format_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_location_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_master_data_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_state_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/save_ad_request.dart';
import 'package:dio/dio.dart';

class AdvertisementRepository {
  final ApiClient apiClient;

  AdvertisementRepository({required this.apiClient});

  static const String _masterDataEndpoint =
      '/api/Advertisement/GetMasterData'; // Mock endpoint
  static const String _saveAdEndpoint = '/api/Advertisement/SaveAd';

  /// Fetch master data for advertisement (locations, formats, states, categories)
  Future<AppResponse<AdMasterDataModel>> getMasterData() async {
    try {
      // 1. Hardcoded Locations and Formats (usually fixed in UI)
      final locations = [
        AdLocationModel(id: 1, name: 'Home Page', value: 'Home'),
        AdLocationModel(id: 2, name: 'Listing Page', value: 'Listing'),
        AdLocationModel(id: 3, name: 'Final Page', value: 'Final'),
      ];

      final formats = [
        AdFormatModel(
          id: 1,
          name: 'Banner (Full size)',
          value: 'Banner',
          description: 'Top position display',
        ),
        AdFormatModel(
          id: 2,
          name: 'In-Between Listing',
          value: 'InBetween',
          description: 'Native look & feel',
        ),
      ];

      // 2. Fetch States from API (using location details endpoint pattern)
      // Note: Since there isn't a dedicated "get-all-states" endpoint visible, 
      // and onboarding uses pincode to get state, we use a common list or 
      // if the API provides a master list we should use that. 
      // For now, we'll keep a robust list that matches the system's expected State names.
      final states = [
        AdStateModel(id: 1, name: 'Andhra Pradesh'),
        AdStateModel(id: 2, name: 'Arunachal Pradesh'),
        AdStateModel(id: 3, name: 'Assam'),
        AdStateModel(id: 4, name: 'Bihar'),
        AdStateModel(id: 5, name: 'Chhattisgarh'),
        AdStateModel(id: 6, name: 'Goa'),
        AdStateModel(id: 7, name: 'Gujarat'),
        AdStateModel(id: 8, name: 'Haryana'),
        AdStateModel(id: 9, name: 'Himachal Pradesh'),
        AdStateModel(id: 10, name: 'Jharkhand'),
        AdStateModel(id: 11, name: 'Karnataka'),
        AdStateModel(id: 12, name: 'Kerala'),
        AdStateModel(id: 13, name: 'Madhya Pradesh'),
        AdStateModel(id: 14, name: 'Maharashtra'),
        AdStateModel(id: 15, name: 'Manipur'),
        AdStateModel(id: 16, name: 'Meghalaya'),
        AdStateModel(id: 17, name: 'Mizoram'),
        AdStateModel(id: 18, name: 'Nagaland'),
        AdStateModel(id: 19, name: 'Odisha'),
        AdStateModel(id: 20, name: 'Punjab'),
        AdStateModel(id: 21, name: 'Rajasthan'),
        AdStateModel(id: 22, name: 'Sikkim'),
        AdStateModel(id: 23, name: 'Tamil Nadu'),
        AdStateModel(id: 24, name: 'Telangana'),
        AdStateModel(id: 25, name: 'Tripura'),
        AdStateModel(id: 26, name: 'Uttar Pradesh'),
        AdStateModel(id: 27, name: 'Uttarakhand'),
        AdStateModel(id: 28, name: 'West Bengal'),
        AdStateModel(id: 29, name: 'Andaman and Nicobar Islands'),
        AdStateModel(id: 30, name: 'Chandigarh'),
        AdStateModel(id: 31, name: 'Dadra and Nagar Haveli and Daman and Diu'),
        AdStateModel(id: 32, name: 'Delhi'),
        AdStateModel(id: 33, name: 'Jammu and Kashmir'),
        AdStateModel(id: 34, name: 'Ladakh'),
        AdStateModel(id: 35, name: 'Lakshadweep'),
        AdStateModel(id: 36, name: 'Puducherry'),
      ];

      // 3. Fetch Categories from API (using the search endpoint with empty term or common categories)
      final categoryResponse = await apiClient.get(
        '/api/auth/search',
        queryParameters: {'term': ''},
      );

      List<AdCategoryModel> categories = [];
      if (categoryResponse.success && categoryResponse.data is List) {
        final list = categoryResponse.data as List;
        categories = list.map((item) {
          return AdCategoryModel(
            id: int.tryParse(item['KeywordId']?.toString() ?? '0') ?? 0,
            name: item['DisplayName']?.toString() ?? '',
            value: item['DisplayName']?.toString() ?? '',
          );
        }).toList();
      }

      return AppResponse(
        success: true,
        message: 'Master data loaded successfully',
        data: AdMasterDataModel(
          locations: locations,
          formats: formats,
          states: states,
          categories: categories,
        ),
      );
    } catch (e) {
      return AppResponse(
        success: false,
        message: 'Failed to load master data: ${e.toString()}',
      );
    }
  }

  /// Save advertisement with image
  Future<AppResponse<Map<String, dynamic>>> saveAdvertisement({
    required SaveAdRequest request,
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...request.toJson(),
        'AdImage': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await apiClient.post(
        _saveAdEndpoint,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AppResponse(
          success: true,
          message: 'Advertisement posted successfully',
          data: response.data as Map<String, dynamic>?,
        );
      }

      return AppResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to post advertisement',
      );
    } on DioException catch (e) {
      return AppResponse(
        success: false,
        message: e.message ?? 'Network error occurred',
      );
    } catch (e) {
      return AppResponse(
        success: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }
}
