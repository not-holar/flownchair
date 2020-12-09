import 'package:flownchair/widgets/app_icon.dart';
import 'package:flownchair/widgets/glance.dart';
import 'package:flownchair/widgets/overscroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';

final drawerIsOpenProvider = StateProvider((ref) => false);

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static const desktop = Desktop(key: Key("desktop"));
  static const drawer = Drawer(key: Key("drawer"));

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
      body: WillPopScope(
        onWillPop: () async {
          context.read(drawerIsOpenProvider).state = false;
          return false;
        },
        child: Consumer(
          builder: (context, watch, _) {
            return Navigator(
              onPopPage: (route, dynamic result) {
                print("onPopPage");

                if (!route.didPop(result)) {
                  return false;
                }
                context.read(drawerIsOpenProvider).state = false;
                return true;
              },
              pages: <Page<bool>>[
                const MaterialPage(
                  key: ValueKey("Home"),
                  name: '/',
                  child: desktop,
                ),
                if (watch(drawerIsOpenProvider).state)
                  const MaterialPage(
                    key: ValueKey("Drawer"),
                    name: '/drawer',
                    child: drawer,
                  ),
              ],
            );
          },
        ),
      ),
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

class Desktop extends StatelessWidget {
  const Desktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Overscroller(
      test: (metrics) => metrics.pixels < -100,
      onOverscroll: () => context.read(drawerIsOpenProvider).state = true,
      child: const CustomScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        clipBehavior: Clip.none,
        reverse: true,
        slivers: [
          SliverFillRemaining(
            child: Align(
              alignment: Alignment(0.0, -0.05),
              child: HomeGlance(),
            ),
          ),
        ],
      ),
    );
  }
}

class Drawer extends StatelessWidget {
  const Drawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: 30,
        borderRadius: BorderRadius.circular(16),
        child: Overscroller(
          test: (metrics) => metrics.pixels < -100,
          onOverscroll: () => context.read(drawerIsOpenProvider).state = false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 55,
                    mainAxisSpacing: 40,
                    crossAxisSpacing: 20,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const Center(
                      child: AppIcon(
                        icon: FlutterLogo(),
                      ),
                    ),
                    childCount: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
