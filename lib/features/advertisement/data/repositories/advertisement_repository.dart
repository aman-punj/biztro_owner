import 'dart:io';

import 'package:bizrato_owner/core/constants/app_assets.dart';
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

  static const String _categoriesEndpoint = '/api/common/categories';
  static const String _statesEndpoint = '/api/common/states';
  static const String _saveAdEndpoint = '/api/Advertisement/SaveAd';

  /// Fetch master data for advertisement (locations, formats, states, categories)
  Future<AppResponse<AdMasterDataModel>> getMasterData() async {
    try {
      // 1. Hardcoded Locations and Formats (usually fixed in UI)
      var locations = [
        AdLocationModel(
          id: 1,
          name: 'Home Page',
          value: 'Home',
          subtitle: 'Maximum visibility for all users',
          iconPath: AppAssets.adLocationHome,
        ),
        AdLocationModel(
          id: 2,
          name: 'Listing Page',
          value: 'Listing',
          subtitle: 'Show ads in search result',
          iconPath: AppAssets.adLocationListing,
        ),
        AdLocationModel(
          id: 3,
          name: 'Final Page',
          value: 'Final',
          subtitle: 'High intent lead conversion',
          iconPath: AppAssets.adLocationFinal,
        ),
      ];

      var formats = [
        AdFormatModel(
          id: 1,
          name: 'Banner (Full size)',
          value: 'Banner',
          description: '',
          leadingText: 'Top position display',
          iconPath: AppAssets.adFormatBanner,
        ),
        AdFormatModel(
          id: 2,
          name: 'View',
          value: 'InBetween',
          description: 'Native look and feel',
          leadingText: 'In between listing',
          iconPath: AppAssets.adFormatView,
        ),
      ];

      final statesResponse = await apiClient.get(_statesEndpoint);
      if (!statesResponse.success || statesResponse.data is! List) {
        return AppResponse(
          success: false,
          message: statesResponse.message.isNotEmpty
              ? statesResponse.message
              : 'Failed to load states.',
        );
      }

      final categoriesResponse = await apiClient.get(_categoriesEndpoint);
      if (!categoriesResponse.success || categoriesResponse.data is! List) {
        return AppResponse(
          success: false,
          message: categoriesResponse.message.isNotEmpty
              ? categoriesResponse.message
              : 'Failed to load categories.',
        );
      }

      final states = _parseList(
        statesResponse.data as List,
        AdStateModel.fromJson,
      );
      final categories = _parseList(
        categoriesResponse.data as List,
        AdCategoryModel.fromJson,
      );

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
    } catch (_) {
      return AppResponse(
        success: false,
        message: 'Failed to load advertisement data. Please try again.',
      );
    }
  }

  List<T> _parseList<T>(
    List<dynamic> list,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return list
        .whereType<Map>()
        .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
        .map(fromJson)
        .toList();
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

      if (response.success) {
        return AppResponse(
          success: true,
          message: 'Advertisement posted successfully',
          data: response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : null,
        );
      }

      return AppResponse(
        success: false,
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to post advertisement',
      );
    } on DioException catch (_) {
      return AppResponse(
        success: false,
        message: 'Network error occurred. Please try again.',
      );
    } catch (_) {
      return AppResponse(
        success: false,
        message: 'Failed to post advertisement. Please try again.',
      );
    }
  }
}
