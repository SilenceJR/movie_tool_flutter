// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute, $movieDetailsRoute];

RouteBase get $homeRoute =>
    GoRouteData.$route(path: '/home', factory: $HomeRoute._fromState);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $movieDetailsRoute => GoRouteData.$route(
  path: '/movie/details',
  factory: $MovieDetailsRoute._fromState,
);

mixin $MovieDetailsRoute on GoRouteData {
  static MovieDetailsRoute _fromState(GoRouterState state) => MovieDetailsRoute(
    id: state.uri.queryParameters['id'],
    movie: _$convertMapValue('movie', state.uri.queryParameters, (
      String json0,
    ) {
      return Movie.fromJson(jsonDecode(json0) as Map<String, dynamic>);
    }),
  );

  MovieDetailsRoute get _self => this as MovieDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/movie/details',
    queryParams: {
      if (_self.id != null) 'id': _self.id,
      if (_self.movie != null) 'movie': jsonEncode(_self.movie!.toJson()),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}
