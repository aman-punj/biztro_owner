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
    required String address,
    required String streetNo,
    required String landmark,
    required String pincode,
    required String stateName,
    required String cityName,
    required bool hasSelectedArea,
  }) {
    if (fullName.trim().isEmpty) {
      return 'Full name is required.';
    }
    if (address.trim().isEmpty) {
      return 'Building / Shop No. is required.';
    }
    if (streetNo.trim().isEmpty) {
      return 'Street Name is required.';
    }
    if (landmark.trim().isEmpty) {
      return 'Landmark is required.';
    }
    if (pincode.trim().isEmpty) {
      return 'Pincode is required.';
    }
    if (pincode.trim().length != 6) {
      return 'Pincode must be 6 digits.';
    }
    if (stateName.trim().isEmpty || cityName.trim().isEmpty) {
      return 'Please enter a valid pincode to fetch City and State.';
    }
    if (!hasSelectedArea) {
      return 'Please select an area.';
    }

    return null;
  }
}
