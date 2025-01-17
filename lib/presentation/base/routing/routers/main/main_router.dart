import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/routing/cubit_route_builder.dart';
import 'package:voca/presentation/home/home_screen.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_cubit.dart';
import 'package:voca/presentation/learning_list/learning_list_screen.dart';
import 'package:voca/presentation/nav_bar/tab_bar_shell_screen.dart';
import 'package:voca/presentation/nav_bar/tab_routers/home_router.dart';
import 'package:voca/presentation/nav_bar/tab_routers/settings_tab_router_screen.dart';
import 'package:voca/presentation/practice/cubit/practice_cubit.dart';
import 'package:voca/presentation/practice/practice_screen.dart';
import 'package:voca/presentation/settings/settings_screen.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_definition/word_definition_screen.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

part 'main_router.gr.dart';

@AutoRouterConfig()
class MainRouter extends _$MainRouter {
  MainRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: TabBarShellRoute.page,
          initial: true,
          children: [
            CustomRoute(
              page: HomeTabRoute.page,
              children: [
                CustomRoute(
                  page: HomeRoute.page,
                  customRouteBuilder: routeBuilder(),
                ),
              ],
            ),
            CustomRoute(
              page: SettingsTabRoute.page,
              children: [
                CustomRoute(
                  page: SettingsRoute.page,
                  customRouteBuilder: routeBuilder(),
                ),
                CustomRoute(
                  page: LearningListRoute.page,
                  customRouteBuilder: cubitRouteBuilder<LearningListCubit>(),
                ),
                CustomRoute(
                  page: WordDefinitionRoute.page,
                  customRouteBuilder: cubitRouteBuilder<WordDefinitionCubit>(),
                ),
              ],
            ),
          ],
        ),
        CustomRoute(
          page: WordSearchRoute.page,
          customRouteBuilder: cubitRouteBuilder<SearchCubit>(),
        ),
        CustomRoute(
          page: WordDefinitionRoute.page,
          customRouteBuilder: cubitRouteBuilder<WordDefinitionCubit>(),
        ),
        CustomRoute(
          page: PracticeRoute.page,
          customRouteBuilder: cubitRouteBuilder<PracticeCubit>(),
        ),
      ];
}
