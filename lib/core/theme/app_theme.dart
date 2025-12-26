import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Blue gradient
  static const Color primaryColor = Color(0xFF4E7FFF);
  static const Color primaryDarkColor = Color(0xFF3D6FEE);
  static const Color primaryLightColor = Color(0xFFE8EEFF);

  // Secondary/Accent Colors
  static const Color secondaryColor = Color(0xFF00D9A3);
  static const Color accentColor = Color(0xFFFF5FA3);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF8F9FD);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF1A1D2E);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color textTertiaryColor = Color(0xFF9CA3AF);

  // Message Colors
  static const Color senderBubbleColor = Color(0xFF4E7FFF);
  static const Color receiverBubbleColor = Color(0xFFF3F4F6);
  static const Color senderTextColor = Colors.white;
  static const Color receiverTextColor = Color(0xFF1A1D2E);

  // Avatar Colors - Matching image
  static const List<Color> avatarColors = [
    Color(0xFF7C3AED), // Purple - Alice
    Color(0xFF4E7FFF), // Blue - Bob
    Color(0xFFEC4899), // Pink - Carol
    Color(0xFF8B5CF6), // Violet - David
    Color(0xFFFF6B9D), // Rose - Emma
    Color(0xFF06B6D4), // Cyan - Frank
    Color(0xFF8B5CF6), // Purple - Grace
    Color(0xFF6366F1), // Indigo - Henry
    Color(0xFF00D9A3), // Green
    Color(0xFFFFB800), // Yellow
  ];

  // Status Colors
  static const Color onlineColor = Color(0xFF00D9A3);
  static const Color offlineColor = Color(0xFF9CA3AF);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);

  // Border Colors
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color dividerColor = Color(0xFFE5E7EB);

  // Tab Colors
  static const Color tabSelectedBg = Color(0xFFE8EEFF);
  static const Color tabSelectedText = Color(0xFF4E7FFF);
  static const Color tabUnselectedText = Color(0xFF6B7280);

  // Shadow
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 12,
    offset: Offset(0, 2),
  );

  static const BoxShadow bottomSheetShadow = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 24,
    offset: Offset(0, -4),
  );

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: surfaceColor,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textPrimaryColor,
    onError: Colors.white,
  );

  // Get avatar color by index
  static Color getAvatarColor(int index) {
    return avatarColors[index % avatarColors.length];
  }

  // Get color from name (for consistent avatar colors)
  static Color getColorFromName(String name) {
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return avatarColors[hash.abs() % avatarColors.length];
  }
}
