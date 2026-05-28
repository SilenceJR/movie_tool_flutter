import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_tool/util/log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:dio/dio.dart';

part 'tmdb_provider.freezed.dart';

part 'tmdb_provider.g.dart';

final _api = TMDB(
  ApiKeys(
    '9731293a896050ac5060a26cce80076b',
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5NzMxMjkzYTg5NjA1MGFjNTA2MGEyNmNjZTgwMDc2YiIsIm5iZiI6MTYzNTkxNzkxOS40MDgsInN1YiI6IjYxODIyMDVmYTA5N2RjMDA0MjhhOTdhNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P0__D4awgf_TUY8yIoKuJC28gI3kXGxDC5DRR9_W_XI',
  ),
  logConfig: ConfigLogger.showAll(),
  dio: Dio()
    ..interceptors.add(
      TalkerDioLogger(
        talker: Log.instance.talker,
        settings: TalkerDioLoggerSettings(),
      ),
    )
    ..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (uri) {
          return 'PROXY 127.0.0.1:7890';
        };
        return client;
      },
    ),
);

@riverpod
class PopularNotifier extends _$PopularNotifier {
  List<Movie> movies = [];

  @override
  Future<List<Movie>> build({
    String language = 'zh-CN',
    String? region,
  }) async => movies;

  Future<void> getData({String? language, int page = 1, String? region}) async {
    try {
      final res = await _api.v3.movies.getPopular(
        language: language ?? this.language,
        page: page,
        region: region ?? this.region,
      );
      final results = res['results'] as List;
      final value = results.map((e) => Movie.fromJson(e)).toList();
      if (page == 1) {
        state = AsyncValue.data(value);
      } else {
        state = AsyncValue.data([...state.value ?? [], ...value]);
      }
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// @riverpod
// Future<List<Movie>> populars(
//   Ref ref, {
//   String language = 'zh-CN',
//   int page = 1,
//   String? region,
// }) async {
//   final res = await _api.v3.movies.getPopular(language: language, page: page, region: region);
//   final results = res['results'] as List;
//   return results.map((e) => Movie.fromJson(e)).toList();
// }

@freezed
abstract class Movie with _$Movie {
  //{adult: false, backdrop_path: /wMrV8SLne1jHLeYS0lLrA1Tf86P.jpg, genre_ids: [27, 9648], id: 1304313, title: 木乃伊, original_language: en, original_title: Lee Cronin's The Mummy, overview: 讲述一位记者的年幼女儿在沙漠中神秘失踪并音讯全无。八年后，当她突然出现在家人面前时，这个早已破碎的家庭震惊不已；原本应该是重逢的喜悦，却逐渐演变成一场活生生的恶梦。, popularity: 604.065, poster_path: /c6Lptq5cFZ57TqMhuBgEYlLCxXI.jpg, release_date: 2026-04-15, softcore: false, video: false, vote_average: 8.0, vote_count: 811}

  const factory Movie({
    required int id,
    required bool adult,
    @JsonKey(name: 'original_title') required String originalTitle,
    @JsonKey(name: 'original_language') required String originalLanguage,
    required String title,
    @JsonKey(name: 'genre_ids') required List<int> genreIds,
    @JsonKey(name: 'poster_path') required String posterPath,
    @JsonKey(name: 'backdrop_path') required String? backdropPath,
    required String overview,
    @JsonKey(name: 'release_date') required String releaseDate,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'vote_count') required int voteCount,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}
