import 'package:flownchair/page_transitions.dart';
import 'package:flownchair/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hsluv/extensions.dart';

void main() {
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
        backgroundColor: hsluvToRGBColor(const [75, 0, 95]),
        accentColor: hsluvToRGBColor(const [75, 10, 50]),
        scaffoldBackgroundColor: hsluvToRGBColor(const [75, 0, 95]),
        unselectedWidgetColor: Colors.black26,
        colorScheme: ColorScheme.light(
          background: hsluvToRGBColor(const [75, 0, 95]),
          primary: hsluvToRGBColor(const [75, 10, 50]),
          primaryVariant: hsluvToRGBColor(const [75, 10, 40]),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: hsluvToRGBColor(const [75, 10, 50]),
          foregroundColor: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: hsluvToRGBColor(const [75, 10, 50]),
          actionTextColor: Colors.white,
          contentTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        canvasColor: Colors.white,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map.fromEntries(
            TargetPlatform.values.map(
              (platform) => MapEntry(
                platform,
                const CustomPageTransitionsBuilder(),
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
