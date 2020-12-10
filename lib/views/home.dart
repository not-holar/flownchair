import 'dart:math';

import 'package:flownchair/widgets/app_icon.dart';
import 'package:flownchair/widgets/glance.dart';
import 'package:flownchair/widgets/overscroller.dart';
import 'package:flownchair/widgets/sliver_overscroll_indicator.dart';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intent/action.dart' as android;
import 'package:intent/category.dart' as android;
import 'package:intent/intent.dart' as android;
import 'package:flutter_riverpod/all.dart';

final appsProvider = FutureProvider(
  (ref) => DeviceApps.getInstalledApplications(
    onlyAppsWithLaunchIntent: true,
    includeSystemApps: true,
    includeAppIcons: true,
  ),
);

final sortedAppsProvider = Provider<List<Application>>(
  (ref) {
    final list = List<Application>.of(
      ref.watch(appsProvider).data?.value ?? [],
      growable: false,
    );
    list.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
    );
    return list;
  },
);

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

  static const overscroll = 100;

  @override
  Widget build(BuildContext context) {
    return Overscroller(
      test: (metrics) => metrics.pixels < -overscroll,
      onOverscroll: () => context.read(drawerIsOpenProvider).state = true,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        clipBehavior: Clip.none,
        reverse: true,
        slivers: [
          SliverOverscrollIndicator(
            builder: (_, x) => Align(
              alignment: const Alignment(0, 0.5),
              child: Opacity(
                opacity: max(0, min(1, (x - 32) / (overscroll - 32))),
                child: const Icon(
                  Icons.keyboard_arrow_up,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: const Alignment(0.0, -0.05),
              child: GestureDetector(
                onTap: () => android.Intent()
                  ..setAction(android.Action.ACTION_MAIN)
                  ..addCategory(android.Category.CATEGORY_APP_CALENDAR)
                  ..startActivity(),
                child: const HomeGlance(),
              ),
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

  static const overscroll = 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appNameTheme = theme.textTheme.caption?.apply(
      fontSizeFactor: .8,
      fontFamily: "RobotoCondensed",
      // fontWeightDelta: 1,
    );

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: 30,
        borderRadius: BorderRadius.circular(16),
        child: Overscroller(
          test: (metrics) => metrics.pixels < -overscroll,
          onOverscroll: () => context.read(drawerIsOpenProvider).state = false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverOverscrollIndicator(
                builder: (_, x) => Align(
                  alignment: const Alignment(0, 0.5),
                  child: Opacity(
                    opacity: 0.5 * max(0, min(1, (x - 32) / (overscroll - 32))),
                    child: const Icon(Icons.keyboard_arrow_down, size: 32),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 65),
                sliver: Consumer(builder: (context, watch, _) {
                  final apps = watch(sortedAppsProvider);

                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 74,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: .575,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final app = apps[index];

                        return GestureDetector(
                          onTap: () => DeviceApps.openApp(app.packageName),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: AppIcon(
                                icon: app is ApplicationWithIcon
                                    ? Image.memory(app.icon)
                                    : Center(
                                        child: Text(
                                          app.appName.characters
                                              .take(1)
                                              .toString(),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              app.appName,
                              style: appNameTheme,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ]),
                        );
                      },
                      childCount: apps.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
