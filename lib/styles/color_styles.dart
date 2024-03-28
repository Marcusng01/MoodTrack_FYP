import 'package:flutter/material.dart';

class AppColors {
  //Dark Blue
  static const Color blueSurface = Color(0xFF0375D2);
  static const Color lightBlueSurface = Color.fromARGB(255, 228, 243, 255);
  static const Color greySurface = Color(0xFFE8E8E8);
  static const Color whiteSurface = Color(0xFFFFFFFF);

  static const Color blackText = Color(0xFF000000);
  static const Color greyText = Color(0xFF7C757E);
  static const Color blueText = Color(0xFF0375D2);
  static const Color whiteText = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFFFFFF);

  // Add more colors as needed
  Color ratingColor(rating) {
    Color color = Colors.transparent;
    if (rating == 'great') {
      color = Colors.purple;
    } else if (rating == 'good') {
      color = Colors.blue;
    } else if (rating == 'average') {
      color = Colors.yellow;
    } else if (rating == 'bad') {
      color = Colors.red;
    } else if (rating == 'awful') {
      color = Colors.black;
    } else if (rating == 'unsure') {
      color = Colors.grey;
    }
    return color;
  }

  static Color getColorForEmotion(String emotion, Color defaultColor) {
    switch (emotion.toLowerCase()) {
      case 'admiration':
        return const Color(0xFFE57373);
      case 'amusement':
        return const Color(0xFF81C784);
      case 'anger':
        return const Color(0xFFEF5350);
      case 'annoyance':
        return const Color(0xFF757575);
      case 'approval':
        return const Color(0xFF4DB6AC);
      case 'caring':
        return const Color(0xFFE57373);
      case 'confusion':
        return const Color(0xFFBA68C8);
      case 'curiosity':
        return const Color(0xFF9575CD);
      case 'desire':
        return const Color(0xFFFFB74D);
      case 'disappointment':
        return const Color(0xFFA1887F);
      case 'disapproval':
        return const Color(0xFFB0BEC5);
      case 'disgust':
        return const Color(0xFF8D6E63);
      case 'embarrassment':
        return const Color(0xFFE57373);
      case 'excitement':
        return const Color(0xFFFFB74D);
      case 'fear':
        return const Color(0xFF607D8B);
      case 'gratitude':
        return const Color(0xFF4CAF50);
      case 'grief':
        return const Color(0xFF455A64);
      case 'joy':
        return const Color(0xFFFFD54F);
      case 'love':
        return const Color(0xFFFF8A80);
      case 'nervousness':
        return const Color(0xFFE57373);
      case 'optimism':
        return const Color(0xFF4CAF50);
      case 'pride':
        return const Color(0xFF7E57C2);
      case 'realization':
        return const Color(0xFFFF8A80);
      case 'relief':
        return const Color(0xFF4DB6AC);
      case 'remorse':
        return const Color(0xFFA1887F);
      case 'sadness':
        return const Color.fromARGB(255, 44, 188, 255);
      case 'surprise':
        return const Color(0xFFBA68C8);
      case 'neutral':
        return defaultColor;
      default:
        return defaultColor; // Default color for unknown emotions
    }
  }

  static Color darken(Color color, [double factor = 0.2]) {
    // Ensure the factor is between 0 and 1
    final double computedFactor = factor.clamp(0.0, 1.0);

    // Calculate the new color components by applying the factor
    final int red = (color.red * (1 - computedFactor)).round();
    final int green = (color.green * (1 - computedFactor)).round();
    final int blue = (color.blue * (1 - computedFactor)).round();

    // Return the new color
    return Color.fromRGBO(red, green, blue, 1);
  }
}
