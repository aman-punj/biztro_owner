import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTokens {
  AppTokens._();

  // Backgrounds
  static const Color screenBackground =
      AppColors.backgroundLight; // Default app screen background
  static const Color screenBackgroundInverse =
      AppColors.backgroundDark; // Dark app background
  static const Color cardBackground =
      AppColors.cardLight; // Primary card/container background
  static const Color surface =
      AppColors.surfaceLight; // Secondary light surface
  static const Color surfaceInverse =
      AppColors.surfaceDark; // Secondary dark surface
  static const Color inputBackground =
      AppColors.textFieldBackground; // Form input background
  static const Color profileBackground =
      AppColors.profileCardBackground; // Business/profile summary background
  static const Color livenessBackground =
      AppColors.livenessBackground; // KYC/live camera surface
  static const Color selectionBackground =
      AppColors.optionSelectedBackground; // Selected option tile fill
  static const Color errorSurface =
      AppColors.errorSurfaceLight; // Error icon/background fill

  // Text
  static const Color textPrimary =
      AppColors.textPrimaryLight; // Default primary text
  static const Color textPrimaryInverse =
      AppColors.textPrimaryDark; // Text on dark surfaces
  static const Color textSecondary =
      AppColors.textSecondaryLight; // Default secondary text
  static const Color textSecondaryInverse =
      AppColors.textSecondaryDark; // Secondary text on dark surfaces
  static const Color textOnBrand =
      AppColors.white; // Text on brand-colored surfaces

  // Brand
  static const Color brandPrimary =
      AppColors.primary; // Primary brand/action color
  static const Color brandPrimaryDark =
      AppColors.primaryDark; // Pressed/deeper brand color
  static const Color brandAccent =
      AppColors.profileIndicator; // Profile/accent highlight
  static const Color info =
      AppColors.infoBlue; // Info/accent blue for icons and highlights
  static const Color star = AppColors.starYellow; // Ratings/star accent

  // States
  static const Color error = AppColors.error; // Error/destructive state
  static const Color online =
      AppColors.onlineIndicator; // Online/presence state
  static const Color white = AppColors.white; // Pure white utility

  // Borders
  static const Color border = AppColors.borderLight; // Default light border
  static const Color borderInverse =
      AppColors.borderDark; // Default dark border
  static const Color profileBorder =
      AppColors.profileCardBorder; // Profile card border
  static const Color errorBorder =
      AppColors.errorBorderLight; // Error surface border

  // Component-specific
  static const Color insightIconBlue =
      AppColors.insightIconBlue; // Dashboard stat icon background
  static const Color insightIconPeach =
      AppColors.insightIconPeach; // Dashboard stat icon background
  static const Color insightIconLavender =
      AppColors.insightIconLavender; // Dashboard stat icon background
  static const Color insightIconMint =
      AppColors.insightIconMint; // Dashboard stat icon background
  static const List<Color> avatarPalette =
      AppColors.avatarPalette; // Conversation avatar fallback palette
}
