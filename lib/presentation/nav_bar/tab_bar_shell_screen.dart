import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/word_search/widgets/word_search_bar.dart';
import 'package:voca/presentation/word_search/widgets/search_bar_hero_data.dart';

@RoutePage()
class TabBarShellScreen extends StatelessWidget {
  const TabBarShellScreen({
    super.key,
  });

  static final homeTabKey = UniqueKey();
  static final settingsTabKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    // final theme = Theme.of(context);

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final router = AutoTabsRouter.of(context);

        return Scaffold(
          body: buildChildWithHiddenSearchBar(child),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(WordSearchRoute());
            },
            child: const Icon(
              Icons.add_rounded,
              size: 32,
            ),
          ),
          bottomNavigationBar: NavigationBar(
            height: 64,
            elevation: 5,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            selectedIndex: router.activeIndex,
            onDestinationSelected: (index) {
              if (router.activeIndex == index) {
                final tabRouter = router.childControllers[index] as StackRouter;
                tabRouter.popUntilRoot();
                return;
              }

              router.setActiveIndex(index);
            },
            destinations: [
              NavigationDestination(
                key: homeTabKey,
                icon: const Icon(Icons.home),
                label: t.navBar.home,
              ),
              NavigationDestination(
                key: settingsTabKey,
                icon: const Icon(Icons.settings),
                label: t.navBar.settings,
              ),
            ],
          ),
        );
      },
    );
  }

  Stack buildChildWithHiddenSearchBar(Widget child) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        buildHiddenSearchBar(),
        child,
      ],
    );
  }

  Widget buildHiddenSearchBar() {
    return Builder(builder: (context) {
      final index = context.watchTabsRouter.activeIndex;

      if (index == 0) {
        return const SizedBox.shrink();
      }

      return const Positioned(
        top: -80,
        right: 16,
        left: 16,
        child: Hero(
          tag: SearchBarHeroData.tag,
          child: Material(
            type: MaterialType.transparency,
            child: WordSearchBar(
              elevation: 0,
            ),
          ),
        ),
      );
    });
  }
}
