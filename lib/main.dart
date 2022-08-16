import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sticker_import/components/flutter/no_margin_rect_slider_track_shape.dart';
import 'package:sticker_import/components/flutter/no_overscroll_behavior.dart';
import 'package:sticker_import/components/flutter/theme_color.dart';
import 'package:sticker_import/flows/start/nav.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/user_list.dart';
import 'package:sticker_import/utils/debugging.dart';

import 'services/native/method_channels.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // ignore: unawaited_futures
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  MethodChannelStore.packageInfo = await PackageInfo.fromPlatform();

  try {
    await UserList.update();
  } catch (e) {
    iLog(e);
  }

  runApp(const TginfoMoverApp());
}

class TginfoMoverApp extends StatelessWidget {
  const TginfoMoverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.from(
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        onPrimary: Color(0xFFAC1B24),
        secondary: Colors.white,
        onSecondary: Color(0xFFAC1B24),
      ),
    );

    final darkTheme = ThemeData.dark();

    return MaterialApp(
      title: 'Sticker Importer',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoOverscrollBehavior(),
          child: child!,
        );
      },
      theme: theme.copyWith(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white.withOpacity(0.75),
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
        primaryColor: ThemeColor.swatch,
        primaryColorLight: const Color(0xFFe6bbbd),
        primaryColorDark: const Color(0xFF671016),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFAC1B24)),
            overlayColor: MaterialStateProperty.all<Color>(
                const Color(0xFFAC1B24).withAlpha(50)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFAC1B24)),
            overlayColor: MaterialStateProperty.all<Color>(
                const Color(0xFFAC1B24).withAlpha(50)),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) =>
                !states.contains(MaterialState.disabled)
                    ? const Color(0xFFAC1B24)
                    : null,
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return const Color(0xFFAC1B24);
            }
            return Colors.white;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return const Color(0xFFAC1B24).withAlpha(50);
            }
            return Colors.black.withAlpha(100);
          }),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: const Color(0xFFAC1B24),
          selectionColor: const Color(0xFFAC1B24).withAlpha(50),
          selectionHandleColor: const Color(0xFFAC1B24),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFFAC1B24),
          inactiveTrackColor: const Color(0xFFAC1B24).withAlpha(50),
          overlayColor: const Color(0xFFAC1B24).withAlpha(50),
          thumbColor: const Color(0xFFAC1B24),
          trackHeight: 3,
          trackShape: NoMarginRectSliderTrackShape(),
          valueIndicatorColor: const Color(0xFFAC1B24),
          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          showValueIndicator: ShowValueIndicator.always,
          thumbShape: const RoundSliderThumbShape(
            elevation: 0,
            pressedElevation: 0,
            enabledThumbRadius: 6,
            disabledThumbRadius: 4,
          ),
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFAC1B24),
        ),
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFAC1B24),
              width: 2,
            ),
          ),
          floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
            if (states.contains(MaterialState.focused)) {
              return theme.textTheme.caption!.copyWith(
                color: const Color(0xFFAC1B24),
              );
            }

            return theme.textTheme.subtitle1!;
          }),
          iconColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.focused)) {
              return const Color(0xFFAC1B24);
            }

            return Colors.black45;
          }),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFFAC1B24),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: darkTheme.copyWith(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey[850]!.withOpacity(0.75),
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
        sliderTheme: SliderThemeData(
          trackHeight: 3,
          trackShape: NoMarginRectSliderTrackShape(),
          showValueIndicator: ShowValueIndicator.always,
          thumbShape: const RoundSliderThumbShape(
            elevation: 0,
            pressedElevation: 0,
            enabledThumbRadius: 6,
            disabledThumbRadius: 4,
          ),
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) =>
                !states.contains(MaterialState.disabled)
                    ? const Color(0xFFAC1B24)
                    : null,
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return const Color(0xFFd68d92);
            }
            return Colors.white30;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            const interactiveStates = <MaterialState>{MaterialState.selected};
            if (states.any(interactiveStates.contains)) {
              return const Color(0xFFd68d92).withAlpha(50);
            }
            return Colors.white10;
          }),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFFd68d92),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: ThemeColor.swatchLight,
          primaryColorDark: ThemeColor.swatchLight,
          accentColor: ThemeColor.swatchLight,
          brightness: Brightness.dark,
        ).copyWith(secondary: ThemeColor.swatchLight),
      ),
      home: const StartRoute(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
