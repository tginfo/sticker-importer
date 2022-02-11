import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sticker_import/components/flutter/no_margin_rect_slider_track_shape.dart';
import 'package:sticker_import/components/flutter/no_overscroll_behavior.dart';
import 'package:sticker_import/components/flutter/theme_color.dart';
import 'package:sticker_import/flows/start/start.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sticker_import/generated/l10n.dart';

import 'services/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingsStorage.packageInfo = await PackageInfo.fromPlatform();
  runApp(TginfoMoverApp());
}

class TginfoMoverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticker Importer',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoOverscrollBehavior(),
          child: child!,
        );
      },
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          onPrimary: Color(0xFFAC1B24),
          secondary: Colors.white,
          onSecondary: Color(0xFFAC1B24),
        ),
      ).copyWith(
        appBarTheme: AppBarTheme(),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
        primaryColor: ThemeColor.swatch,
        primaryColorLight: Color(0xFFe6bbbd),
        primaryColorDark: Color(0xFF671016),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(Color(0xFFAC1B24)),
            overlayColor: MaterialStateProperty.all<Color>(
                Color(0xFFAC1B24).withAlpha(50)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(Color(0xFFAC1B24)),
            overlayColor: MaterialStateProperty.all<Color>(
                Color(0xFFAC1B24).withAlpha(50)),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) =>
                !states.contains(MaterialState.disabled)
                    ? Color(0xFFAC1B24)
                    : null,
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return Color(0xFFAC1B24);
            }
            return Colors.white;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return Color(0xFFAC1B24).withAlpha(50);
            }
            return Colors.black.withAlpha(100);
          }),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFAC1B24),
          selectionColor: Color(0xFFAC1B24).withAlpha(50),
          selectionHandleColor: Color(0xFFAC1B24),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Color(0xFFAC1B24),
          inactiveTrackColor: Color(0xFFAC1B24).withAlpha(50),
          overlayColor: Color(0xFFAC1B24).withAlpha(50),
          thumbColor: Color(0xFFAC1B24),
          trackHeight: 3,
          trackShape: NoMarginRectSliderTrackShape(),
          valueIndicatorColor: Color(0xFFAC1B24),
          valueIndicatorTextStyle: TextStyle(color: Colors.white),
          showValueIndicator: ShowValueIndicator.always,
          thumbShape: RoundSliderThumbShape(
            elevation: 0,
            pressedElevation: 0,
            enabledThumbRadius: 6,
            disabledThumbRadius: 4,
          ),
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
        sliderTheme: SliderThemeData(
          trackHeight: 3,
          trackShape: NoMarginRectSliderTrackShape(),
          showValueIndicator: ShowValueIndicator.always,
          thumbShape: RoundSliderThumbShape(
            elevation: 0,
            pressedElevation: 0,
            enabledThumbRadius: 6,
            disabledThumbRadius: 4,
          ),
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) =>
                !states.contains(MaterialState.disabled)
                    ? Color(0xFFAC1B24)
                    : null,
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return Color(0xFFd68d92);
            }
            return Colors.white30;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return Color(0xFFd68d92).withAlpha(50);
            }
            return Colors.white10;
          }),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: ThemeColor.swatchLight,
          primaryColorDark: ThemeColor.swatchLight,
          accentColor: ThemeColor.swatchLight,
          brightness: Brightness.dark,
        ).copyWith(secondary: ThemeColor.swatchLight),
      ),
      home: StartRoute(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
