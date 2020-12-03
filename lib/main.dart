import 'package:flownchair/ordinal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(App());
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

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
          preferredSize: Size.zero,
          child: SizedBox.expand(),
        ),
        body: Column(children: [
          const Expanded(
            child: Align(
              alignment: Alignment(0.0, -0.05),
              child: HomeGlance(),
            ),
          ),
          SafeArea(
            child: SizedBox(
              // color: Colors.redAccent,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(
                    5,
                    (_) => const IconShortcut(
                      icon: FlutterLogo(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
        // CustomScrollView(
        //   physics: BouncingScrollPhysics(),
        //   clipBehavior: Clip.none,
        //   slivers: [
        //     SliverSafeArea(
        //       sliver: SliverPadding(
        //         padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
        //         sliver: SliverList(
        //           delegate: SliverChildListDelegate.fixed([
        //             HomeGlance(),
        //             HomeCard(),
        //           ]),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
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
    return Padding(
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
