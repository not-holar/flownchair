import 'package:flownchair/ordinal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
        backgroundColor: const HSLColor.fromAHSL(1, 75, 0, .95).toColor(),
        accentColor: const HSLColor.fromAHSL(1, 75, .1, .5).toColor(),
        scaffoldBackgroundColor:
            const HSLColor.fromAHSL(1, 75, 0, .95).toColor(),
        unselectedWidgetColor: Colors.black26,
        colorScheme: ColorScheme.light(
          background: const HSLColor.fromAHSL(1, 75, 0, .95).toColor(),
          primary: const HSLColor.fromAHSL(1, 75, .10, .5).toColor(),
          primaryVariant: const HSLColor.fromAHSL(1, 75, .1, .4).toColor(),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const HSLColor.fromAHSL(1, 75, .1, .5).toColor(),
          foregroundColor: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const HSLColor.fromAHSL(1, 75, .1, .5).toColor(),
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

final homeScrollController = Provider(
  (_) => ScrollController(),
);

final homeScrollControllerProvider = ChangeNotifierProvider(
  (ref) => ref.watch(homeScrollController),
);

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

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
      body: Consumer(
        builder: (context, watch, child) {
          return CustomScrollView(
            controller: watch(homeScrollController),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            clipBehavior: Clip.none,
            slivers: const [
              SliverFillRemaining(
                child: Align(
                  alignment: Alignment(0.0, -0.05),
                  child: HomeGlance(),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(
                5,
                (_) => const IconShortcut(
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

class IconShortcut extends StatelessWidget {
  const IconShortcut({Key key, this.icon}) : super(key: key);

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: icon,
      ),
    );
  }
}

class HomeGlance extends StatelessWidget {
  const HomeGlance({Key key}) : super(key: key);

  String formatDate(DateTime date) {
    final f = '${DateFormat.WEEKDAY}, ${DateFormat.ABBR_STANDALONE_MONTH}';
    return '${DateFormat(f).format(date)} ${ordinal[date.day]}';
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Text(
            formatDate(
              DateTime.now(),
            ),
            style: GoogleFonts.megrim(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w700,
              shadows: kElevationToShadow[24],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      child: const Placeholder(),
    );
  }
}
