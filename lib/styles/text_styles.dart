import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Small Text Styles
  static const TextStyle smallBlackText = TextStyle(
    color: AppColors.blackText,
    fontSize: 12.0,
  );

  static const TextStyle smallGreyText = TextStyle(
    color: AppColors.greyText,
    fontSize: 12.0,
  );

  static const TextStyle smallBlueText = TextStyle(
    color: AppColors.blueText,
    fontSize: 12.0,
  );

  static const TextStyle smallWhiteText = TextStyle(
    color: AppColors.whiteText,
    fontSize: 12.0,
  );

  // Medium Text Styles
  static const TextStyle mediumBlackText = TextStyle(
    color: AppColors.blackText,
    fontSize: 16.0,
  );

  static const TextStyle mediumGreyText = TextStyle(
    color: AppColors.greyText,
    fontSize: 16.0,
  );

  static const TextStyle mediumBlueText = TextStyle(
    color: AppColors.blueText,
    fontSize: 16.0,
  );

  static const TextStyle mediumWhiteText = TextStyle(
    color: AppColors.whiteText,
    fontSize: 16.0,
  );

  // Large Text Styles
  static const TextStyle largeBlackText = TextStyle(
    color: AppColors.blackText,
    fontSize: 22.0,
  );

  static const TextStyle largeGreyText = TextStyle(
    color: AppColors.greyText,
    fontSize: 22.0,
  );

  static const TextStyle largeBlueText = TextStyle(
    color: AppColors.blueText,
    fontSize: 22.0,
  );

  static const TextStyle largeWhiteText = TextStyle(
    color: AppColors.whiteText,
    fontSize: 22.0,
  );

  // Large + Bold Text Styles
  static const TextStyle largeBoldBlackText = TextStyle(
    color: AppColors.blackText,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle largeBoldGreyText = TextStyle(
    color: AppColors.greyText,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle largeBoldBlueText = TextStyle(
    color: AppColors.blueText,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle largeBoldWhiteText = TextStyle(
    color: AppColors.whiteText,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  // Add more text styles as needed
  TextStyle ratingTextStyle(rating) {
    TextStyle textStyle = AppTextStyles.smallBlackText;
    if (rating == 'awful') {
      textStyle = AppTextStyles.smallWhiteText;
    }
    return textStyle;
  }
}
