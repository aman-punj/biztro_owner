import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/features/business_edit/data/models/save_social_media_request.dart';
import 'package:bizrato_owner/features/business_edit/data/models/social_media_links_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/area_item_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/business_details_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/business_service_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/contact_info_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/keyword_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/location_details_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_keywords_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_contact_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_service_facilities_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/saved_keywords_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/service_facility_item_model.dart';

class OnboardingRepository {
  OnboardingRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<AppResponse<List<SearchResultModel>>> searchCategory(String term) async {
    final response = await apiClient.get(
      '/api/auth/search',
      queryParameters: {'term': term},
    );

    if (!response.success) {
      return AppResponse<List<SearchResultModel>>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final results = _parseSearchResults(response.data);
    return AppResponse<List<SearchResultModel>>(
      success: true,
      message: response.message,
      data: results,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<List<KeywordModel>>> getKeywords(String categoryId) async {
    final response = await apiClient.get(
      '/api/auth/get-keywords',
      queryParameters: {'categoryId': categoryId},
    );

    if (!response.success) {
      return AppResponse<List<KeywordModel>>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final keywords = _parseKeywordList(response.data);
    return AppResponse<List<KeywordModel>>(
      success: true,
      message: response.message,
      data: keywords,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<void>> saveKeywords(SaveKeywordsRequest request) async {
    final response = await apiClient.post(
      '/api/auth/savekeywords',
      data: request.toJson(),
    );

    if (!response.success) {
      return AppResponse<void>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return AppResponse<void>(
      success: true,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<void>> saveServiceFacilities(
    SaveServiceFacilitiesRequest request,
  ) async {
    final response = await apiClient.post(
      '/api/auth/save-servicefacilities',
      data: request.toJson(),
    );

    if (!response.success) {
      return AppResponse<void>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return AppResponse<void>(
      success: true,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<SavedKeywordsModel>> getSavedKeywords(int merchantId) async {
    final response = await apiClient.get(
      '/api/auth/get-savedkeywords',
      queryParameters: {'merchantId': merchantId},
    );

    if (!response.success) {
      return AppResponse<SavedKeywordsModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<SavedKeywordsModel>.failure(
        message: 'Saved keywords are unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final model = SavedKeywordsModel.fromJson(_forceMap(response.data as Map));
    if (!model.success) {
      return AppResponse<SavedKeywordsModel>.failure(
        message: response.message.isNotEmpty
            ? response.message
            : 'Saved keywords are unavailable.',
        statusCode: response.statusCode,
        data: model,
      );
    }

    return AppResponse<SavedKeywordsModel>(
      success: true,
      message: response.message,
      data: model,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<BusinessDetailsModel>> getBusinessDetails(
    int merchantId,
  ) async {
    final response = await apiClient.get(
      '/api/auth/get-businessdetails',
      queryParameters: {'merchantId': merchantId},
    );

    if (!response.success) {
      return AppResponse<BusinessDetailsModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<BusinessDetailsModel>.failure(
        message: 'Business details are unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final model = BusinessDetailsModel.fromJson(_forceMap(response.data as Map));
    if (!model.isSuccessful) {
      return AppResponse<BusinessDetailsModel>.failure(
        message: model.message.isNotEmpty
            ? model.message
            : 'Business details are unavailable.',
        statusCode: response.statusCode,
        data: model,
      );
    }

    return AppResponse<BusinessDetailsModel>(
      success: true,
      message: model.message.isNotEmpty ? model.message : response.message,
      data: model,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<ContactInfoModel>> getContactInfo(int merchantId) async {
    final response = await apiClient.get(
      '/api/auth/get-business-loccontinfo',
      queryParameters: {'merchantId': merchantId},
    );

    if (!response.success) {
      return AppResponse<ContactInfoModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<ContactInfoModel>.failure(
        message: 'Contact information is unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final model = ContactInfoModel.fromJson(_forceMap(response.data as Map));
    if (!model.isSuccessful) {
      return AppResponse<ContactInfoModel>.failure(
        message: model.message.isNotEmpty
            ? model.message
            : 'Contact information is unavailable.',
        statusCode: response.statusCode,
        data: model,
      );
    }

    return AppResponse<ContactInfoModel>(
      success: true,
      message: model.message.isNotEmpty ? model.message : response.message,
      data: model,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<LocationDetailsModel>> getLocationByPincode(
    String pincode,
  ) async {
    final response = await apiClient.get(
      '/api/auth/get-locationdetails-bypincode',
      queryParameters: {'pincode': pincode},
    );

    if (!response.success) {
      return AppResponse<LocationDetailsModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<LocationDetailsModel>.failure(
        message: 'Location details are unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final model =
        LocationDetailsModel.fromJson(_forceMap(response.data as Map));
    if (!model.success) {
      return AppResponse<LocationDetailsModel>.failure(
        message: response.message.isNotEmpty
            ? response.message
            : 'Location details are unavailable.',
        statusCode: response.statusCode,
        data: model,
      );
    }

    return AppResponse<LocationDetailsModel>(
      success: true,
      message: response.message,
      data: model,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<AreaListModel>> getAreasByPincode(String pincode) async {
    final response = await apiClient.get(
      '/api/auth/get-arealist-bypincode',
      queryParameters: {'pincode': pincode},
    );

    if (!response.success) {
      return AppResponse<AreaListModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<AreaListModel>.failure(
        message: 'Areas are unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final model = AreaListModel.fromJson(_forceMap(response.data as Map));
    if (!model.success) {
      return AppResponse<AreaListModel>.failure(
        message: response.message.isNotEmpty
            ? response.message
            : 'Areas are unavailable.',
        statusCode: response.statusCode,
        data: model,
      );
    }

    return AppResponse<AreaListModel>(
      success: true,
      message: response.message,
      data: model,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<void>> saveContactDetails(
    SaveContactRequest request,
  ) async {
    final response = await apiClient.post(
      '/api/auth/savecontactdetails',
      data: request.toJson(),
    );

    if (!response.success) {
      return AppResponse<void>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return AppResponse<void>(
      success: true,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<SocialMediaLinksModel>> getSocialMediaLinks(
    int merchantId,
  ) async {
    final response = await apiClient.get(
      '/api/socialmedia/socialmedialinks',
      queryParameters: {'MerchantId': merchantId},
    );

    if (!response.success) {
      return AppResponse<SocialMediaLinksModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<SocialMediaLinksModel>.failure(
        message: 'Social media links are unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final model = SocialMediaLinksModel.fromJson(_forceMap(response.data as Map));
    if (!model.success) {
      return AppResponse<SocialMediaLinksModel>.failure(
        message: model.message.isNotEmpty
            ? model.message
            : 'Social media links are unavailable.',
        statusCode: response.statusCode,
        data: model,
      );
    }

    return AppResponse<SocialMediaLinksModel>(
      success: true,
      message: model.message.isNotEmpty ? model.message : response.message,
      data: model,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<void>> saveSocialMedia(
    SaveSocialMediaRequest request,
  ) async {
    final response = await apiClient.post(
      '/api/socialmedia/SaveSocialMedia',
      data: request.toJson(),
    );

    if (!response.success) {
      return AppResponse<void>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return AppResponse<void>(
      success: true,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<BusinessServiceModel>> getBusinessServiceData(
    int merchantId,
  ) async {
    final response = await apiClient.get(
      '/api/auth/get-businessservice-businesscategory',
      queryParameters: {'merchantId': merchantId},
    );

    if (!response.success) {
      return AppResponse<BusinessServiceModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<BusinessServiceModel>.failure(
        message: 'Business service data is unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final model = BusinessServiceModel.fromJson(_forceMap(response.data as Map));
    if (!model.isSuccessful) {
      return AppResponse<BusinessServiceModel>.failure(
        message: model.message.isNotEmpty
            ? model.message
            : 'Unable to load business service data.',
        statusCode: response.statusCode,
        data: model,
      );
    }

    return AppResponse<BusinessServiceModel>(
      success: true,
      message: model.message.isNotEmpty ? model.message : response.message,
      data: model,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<ServiceFacilityListModel>> getServiceFacilitiesList(
    String categoryId,
  ) async {
    final response = await apiClient.get(
      '/api/auth/get-businessservice-servicefacilities-list',
      queryParameters: {'categoryId': categoryId},
    );

    if (!response.success) {
      return AppResponse<ServiceFacilityListModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data == null) {
      return AppResponse<ServiceFacilityListModel>(
        success: true,
        message: response.message,
        data: const ServiceFacilityListModel(
          servicesOffered: <ServiceFacilityItemModel>[],
          facilities: <ServiceFacilityItemModel>[],
        ),
        statusCode: response.statusCode,
      );
    }

    if (response.data is! Map) {
      return AppResponse<ServiceFacilityListModel>.failure(
        message: 'Service and facility data is unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final items =
        ServiceFacilityListModel.fromJson(_forceMap(response.data as Map));
    return AppResponse<ServiceFacilityListModel>(
      success: true,
      message: response.message,
      data: items,
      statusCode: response.statusCode,
    );
  }

  List<SearchResultModel> _parseSearchResults(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((entry) => SearchResultModel.fromJson(_forceMap(entry)))
          .toList();
    }
    return const <SearchResultModel>[];
  }

  List<KeywordModel> _parseKeywordList(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((entry) => KeywordModel.fromJson(_forceMap(entry)))
          .toList();
    }
    return const <KeywordModel>[];
  }

  Map<String, dynamic> _forceMap(Map raw) {
    return raw.cast<String, dynamic>();
  }
}
