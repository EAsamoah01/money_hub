import 'package:flutter/material.dart';

/// Each tab has its own accent color. Wrapping a screen in [ModuleTheme]
/// recolors every Material widget inside it (buttons, cards, charts,
/// progress bars, chips) from that one seed color.
enum AppModule {
  home('Home', Color(0xFF0F766E), Icons.home_outlined, Icons.home), // teal
  budget('Budget', Color(0xFF15803D), Icons.account_balance_wallet_outlined, Icons.account_balance_wallet), // green
  goals('Goals', Color(0xFFC2410C), Icons.flag_outlined, Icons.flag), // orange
  tools('Tools', Color(0xFF4338CA), Icons.calculate_outlined, Icons.calculate), // indigo
  learn('Learn', Color(0xFF7E22CE), Icons.school_outlined, Icons.school); // purple

  const AppModule(this.label, this.seed, this.icon, this.selectedIcon);
  final String label;
  final Color seed;
  final IconData icon;
  final IconData selectedIcon;

  ColorScheme scheme(Brightness b) => AppTheme.schemeFor(seed, b);
}

abstract final class AppTheme {
  static final _schemes = <(Color, Brightness), ColorScheme>{};
  static final _themes = <(Color, Brightness), ThemeData>{};

  static ColorScheme schemeFor(Color seed, Brightness b) => _schemes.putIfAbsent(
        (seed, b),
        () => ColorScheme.fromSeed(
          seedColor: seed,
          brightness: b,
          // Keeps the primary color close to the seed instead of a muted tone.
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      );

  static ThemeData forSeed(Color seed, Brightness b) => _themes.putIfAbsent((seed, b), () => _build(schemeFor(seed, b)));

  static ThemeData get light => forSeed(AppModule.home.seed, Brightness.light);
  static ThemeData get dark => forSeed(AppModule.home.seed, Brightness.dark);

  static ThemeData _build(ColorScheme cs) {
    final base = ThemeData(useMaterial3: true, colorScheme: cs);
    final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    return base.copyWith(
      scaffoldBackgroundColor: cs.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: cs.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cs.surfaceContainerLow,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(shape: rounded)),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: rounded)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      listTileTheme: ListTileThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide(color: cs.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// Applies a module's color theme to everything below it.
class ModuleTheme extends StatelessWidget {
  const ModuleTheme({super.key, required this.module, required this.child});
  final AppModule module;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return Theme(data: AppTheme.forSeed(module.seed, b), child: child);
  }
}
