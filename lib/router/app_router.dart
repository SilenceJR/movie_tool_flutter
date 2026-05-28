import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_tool/page/home/home_page.dart';
import 'package:movie_tool/provider/tmdb_provider.dart';
import 'package:movie_tool/router/app_path.dart';

import '../page/movie/movie_details_page.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(path: AppPath.home)
class HomeRoute extends GoRouteData with $HomeRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@TypedGoRoute<MovieDetailsRoute>(path: AppPath.movieDetails)
class MovieDetailsRoute extends GoRouteData with $MovieDetailsRoute {
  MovieDetailsRoute({this.id, this.movie});

  final String? id;
  final Movie? movie;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MovieDetailsPage(id: id, movie: movie);
}

// @TypedShellRoute<IndexRoute>(
//   routes: [
//
//   ]
// )
// class IndexRoute extends ShellRouteData {
//
//
// }

class AppRouter {
  static GoRouter route = GoRouter(
    initialLocation: AppPath.home,
    restorationScopeId: 'root',
    routes: $appRoutes,
    // routes: [
    //   GoRoute(
    //     path: AppPath.home,
    //     builder: (context, state) => const HomePage(),
    //   ),
    //   GoRoute(
    //     path: AppPath.movieDetails,
    //     builder: (context, state) {
    //       final id = state.path;
    //       final extra = state.extra;
    //       return const MovieDetailsPage();
    //     },
    //   ),
    // ],
  );
}
