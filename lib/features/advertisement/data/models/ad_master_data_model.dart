import 'package:bizrato_owner/features/advertisement/data/models/ad_category_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_format_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_location_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_state_model.dart';

class AdMasterDataModel {
  final List<AdLocationModel> locations;
  final List<AdFormatModel> formats;
  final List<AdStateModel> states;
  final List<AdCategoryModel> categories;

  AdMasterDataModel({
    required this.locations,
    required this.formats,
    required this.states,
    required this.categories,
  });

  factory AdMasterDataModel.fromJson(Map<String, dynamic> json) {
    return AdMasterDataModel(
      locations: (json['locations'] as List?)
              ?.map((e) => AdLocationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      formats: (json['formats'] as List?)
              ?.map((e) => AdFormatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      states: (json['states'] as List?)
              ?.map((e) => AdStateModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories: (json['categories'] as List?)
              ?.map((e) => AdCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locations': locations.map((e) => e.toJson()).toList(),
      'formats': formats.map((e) => e.toJson()).toList(),
      'states': states.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}
