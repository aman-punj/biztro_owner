class OnboardingValidators {
  const OnboardingValidators._();

  static String? validateBusinessServices({
    required String businessName,
    required String estbYear,
  }) {
    if (businessName.trim().isEmpty) {
      return 'Business name is required.';
    }

    final trimmedYear = estbYear.trim();
    if (trimmedYear.isNotEmpty && trimmedYear.length != 4) {
      return 'Establishment year must be exactly 4 digits.';
    }

    return null;
  }

  static String? validateLocationAndContact({
    required String fullName,
    required String email,
    required String mobile,
    required String whatsApp,
    required String businessEmail,
    required String businessWhatsApp,
    required String address,
    required String streetNo,
    required String landmark,
    required String pincode,
    required String stateName,
    required String cityName,
    required bool hasSelectedArea,
  }) {
    // 1. Core Mandatory Fields
    if (fullName.trim().isEmpty) return 'Full name is required.';
    if (email.trim().isEmpty) return 'Email is required.';
    if (mobile.trim().isEmpty) return 'Mobile number is required.';
    if (whatsApp.trim().isEmpty) return 'WhatsApp number is required.';
    if (businessEmail.trim().isEmpty) return 'Business email is required.';
    if (businessWhatsApp.trim().isEmpty) return 'Business WhatsApp is required.';

    // 2. Conditional Location Fields
    // If ANY location field is filled, ALL location fields become mandatory.
    final bool isLocationStarted = address.trim().isNotEmpty ||
        streetNo.trim().isNotEmpty ||
        landmark.trim().isNotEmpty ||
        pincode.trim().isNotEmpty ||
        hasSelectedArea;

    if (isLocationStarted) {
      if (address.trim().isEmpty) return 'Building / Shop No. is required.';
      if (streetNo.trim().isEmpty) return 'Street Name is required.';
      if (landmark.trim().isEmpty) return 'Landmark is required.';
      if (pincode.trim().isEmpty) return 'Pincode is required.';
      if (pincode.trim().length != 6) return 'Pincode must be 6 digits.';
      if (stateName.trim().isEmpty || cityName.trim().isEmpty) {
        return 'Please enter a valid pincode to fetch City and State.';
      }
      if (!hasSelectedArea) return 'Please select an area.';
    }

    return null;
  }
}
