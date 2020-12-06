import 'package:flownchair/glance.dart';
import 'package:flownchair/overscroller.dart';
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
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const PreferredSize(
        preferredSize: Size.zero,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: SizedBox.expand(),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: const HomeTop(),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(
                5,
                (_) => const AppIcon(
                  icon: FlutterLogo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTop extends StatelessWidget {
  const HomeTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Overscroller(
      test: (offset) => offset > 100,
      onOverscrolled: () {
        print("Overscrolled");
      },
      child: const Align(
        alignment: Alignment(0.0, -0.05),
        child: HomeGlance(),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: icon,
      ),
    );
  }
}
