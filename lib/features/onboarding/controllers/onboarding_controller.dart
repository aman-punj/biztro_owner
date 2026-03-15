import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final RxInt _stageIndex = 0.obs;

  int get stageIndex => _stageIndex.value;

  static const List<String> stageTitles = <String>[
    'Basic Info',
    'Keywords',
    'Finalize',
  ];

  static const List<String> serviceCategories = <String>[
    'Mithai',
    'Cakes & Pastries',
    'Chocolates & Cookies',
    'Desserts & Puddings',
  ];

  static const List<String> quantityTags = <String>[
    'Best sweet shop near me',
    'Famous mithai shop',
    'Pure Desi Ghee sweets',
  ];

  static const List<String> servicesOffered = <String>[
    'Traditional Indian Mithai',
    'Customized Gift Hampers',
    'Festival Gifting Specials',
    'Savory Namkeen & Snacks',
    'Live Hot Jalebi Counter',
  ];

  static const List<String> facilities = <String>[
    'Chilled Display Counters',
    'Open View Live Kitchen',
    'Comfortable Dine-In Area',
    'Premium Gifting Station',
    'Live Jalebi & Snacks Counter',
  ];

  final RxString selectedServiceCategory = serviceCategories.first.obs;
  final RxString selectedQuantityTag = quantityTags.first.obs;

  final RxSet<String> selectedServices = <String>{}.obs;
  final RxSet<String> selectedFacilities = <String>{}.obs;

  final RxList<String> customKeywords = <String>[].obs;
  final RxString keywordDraft = ''.obs;

  void nextStage() {
    if (_stageIndex.value < 2) {
      _stageIndex.value += 1;
    }
  }

  void previousStage() {
    if (_stageIndex.value > 0) {
      _stageIndex.value -= 1;
    }
  }

  void goToStage(int index) {
    if (index >= 0 && index <= 2) {
      _stageIndex.value = index;
    }
  }

  void selectServiceCategory(String value) {
    selectedServiceCategory.value = value;
  }

  void selectQuantityTag(String value) {
    selectedQuantityTag.value = value;
  }

  void toggleService(String value) {
    if (selectedServices.contains(value)) {
      selectedServices.remove(value);
    } else {
      selectedServices.add(value);
    }
  }

  void toggleFacility(String value) {
    if (selectedFacilities.contains(value)) {
      selectedFacilities.remove(value);
    } else {
      selectedFacilities.add(value);
    }
  }

  void updateKeywordDraft(String value) {
    keywordDraft.value = value;
  }

  void addCustomKeyword(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty || customKeywords.contains(trimmed)) {
      return;
    }

    customKeywords.add(trimmed);
    keywordDraft.value = '';
  }

  void removeCustomKeyword(String value) {
    customKeywords.remove(value);
  }
}
