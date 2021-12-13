import 'package:flutter/material.dart';

final alpha87 = (255 * 0.87).toInt();
final alpha80 = (255 * 0.80).toInt();
final alpha60 = (255 * 0.60).toInt();
final alpha36 = (255 * 0.36).toInt();
final alpha24 = (255 * 0.24).toInt();
final alpha12 = (255 * 0.12).toInt();
final alpha08 = (255 * 0.08).toInt();

void main() {
  print("[custom-purple-light]");
  print(genTheme(
      bg: Color(0xFFFAFAFA),
      primary: Color(0xFF6A1B9A),
      primaryVariant: Color(0xFF38006B)));

  print("\n[custom-purple-dark]");
  print(genTheme(
      bg: Color(0xFF121212),
      primary: Color(0xFFba68c8),
      primaryVariant: Color(0xFF883997)));
}

String genTheme({Color bg, Color primary, Color primaryVariant}) {
  final surfaceBrightness = ThemeData.estimateBrightnessForColor(bg);
  final isDark = surfaceBrightness == Brightness.dark;
  final primaryBrightness = ThemeData.estimateBrightnessForColor(primary);
  final isPrimaryDark = primaryBrightness == Brightness.dark;

  final onSurface = isDark ? Colors.white : Colors.black;
  final onPrimary = isPrimaryDark ? Colors.white : Colors.black;
  final elevationOverlay4 = isDark ? (255 * 0.09).toInt() : 0;
  if (isDark) {
    bg = Color.alphaBlend(primary.withAlpha(alpha08), bg);
  }
  final primarySurface =
      isDark ? Color.alphaBlend(primary.withAlpha(alpha24), bg) : primary;

  final primaryOrVariantWithSurfaceBrightness =
      primaryBrightness == surfaceBrightness
          ? primary
          : ThemeData.estimateBrightnessForColor(primaryVariant) ==
                  surfaceBrightness
              ? primaryVariant
              : Color.alphaBlend(bg.withAlpha(alpha24), primary);

  final result = <String, Color>{
    'main_fg': primary,
    'main_bg': Color.alphaBlend(onSurface.withAlpha(elevationOverlay4), bg),
    'secondary_fg': Color.alphaBlend(onSurface.withAlpha(alpha87), bg),
    'secondary_bg': primarySurface,
    'selected_button':
        Color.alphaBlend(onSurface.withAlpha(alpha08), primarySurface),
    'pressing_fg':
        Color.alphaBlend(onSurface.withAlpha(alpha12), primarySurface),
    'pressing_button_fg': Color.alphaBlend(primary.withAlpha(alpha60), bg),
    'pressing_button_bg': Color.alphaBlend(onSurface.withAlpha(alpha87), bg),
    'sidebar_and_player_bg': Color.alphaBlend(primary.withAlpha(alpha12), bg),
    'sidebar_indicator_and_hover_button_bg': primarySurface,
    'cover_overlay_and_shadow': primaryVariant,
    'slider_bg': Color.alphaBlend(primary.withAlpha(alpha36), bg),
    'scrollbar_fg_and_selected_row_bg': Color.alphaBlend(
        onSurface.withAlpha(alpha12),
        Color.alphaBlend(primaryVariant.withAlpha(alpha36), bg)),
    'active_control_fg': primary,
    'indicator_fg_and_button_bg': primaryOrVariantWithSurfaceBrightness,
    'miscellaneous_bg': primarySurface,
    'miscellaneous_hover_bg':
        Color.alphaBlend(onSurface.withAlpha(alpha87), bg),
    'preserve_1': isDark ? primary : onPrimary
  };
  return outputString(result);
}

String outputString(Map<String, Color> colors) {
  final buff = StringBuffer();
  var nameLength = 0;
  colors.forEach(
      (name, _) => name.length > nameLength ? nameLength = name.length : null);

  final padding = 1;
  colors.forEach((name, color) {
    buff
      ..write(name)
      ..write(' ' * (nameLength - name.length + padding))
      ..write('= ')
      ..write(hexComponents(color))
      ..write('\n');
  });
  return buff.toString();
}

String htmlColor(Color c, {bool argb = false, bool rgba = false}) {
  var result = '#${hexComponents(c, argb: argb, rgba: rgba)}';
  return result;
}

String hexComponents(Color c, {bool argb = false, bool rgba = false}) {
  assert(!rgba || !argb);
  final r = c.red.toRadixString(16).padLeft(2, '0');
  final g = c.green.toRadixString(16).padLeft(2, '0');
  final b = c.blue.toRadixString(16).padLeft(2, '0');
  final a = c.alpha.toRadixString(16).padLeft(2, '0');
  if (rgba) {
    return '$r$g$b$a';
  }
  if (argb) {
    return '$a$r$g$b';
  }
  return '$r$g$b';
}
