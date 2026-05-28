import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_tool/provider/tmdb_provider.dart';
import 'package:movie_tool/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  PopularNotifierProvider get provider => popularProvider();

  FutureOr loadData(WidgetRef ref, int page) =>
      ref.read(provider.notifier).getData(page: page);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshView(
        data: (ref) => ref.watch(provider),
        onRefresh: loadData,
        onLoad: loadData,
        child: const MovieView(),
      ),
    );
  }
}

class RefreshView<T> extends ConsumerStatefulWidget {
  const RefreshView({
    super.key,
    required this.child,
    this.onRefresh,
    this.onLoad,
    required this.data,
    this.loading,
    this.error,
  });

  final ConsumerWidget child;
  final FutureOr Function(WidgetRef, int)? onRefresh, onLoad;
  final AsyncValue<T> Function(WidgetRef) data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace)? error;

  @override
  ConsumerState createState() => _RefreshViewState();
}

class _RefreshViewState extends ConsumerState<RefreshView> {
  int page = 1;

  @override
  Widget build(BuildContext context) {
    final data = widget.data(ref);
    return EasyRefresh(
      refreshOnStart: true,
      onRefresh: () {
        page = 1;
        widget.onRefresh?.call(ref, page);
      },
      onLoad: () => widget.onLoad?.call(ref, page),
      child: data.when(
        data: (data) {
          page++;
          return widget.child;
        },
        error: widget.error ?? (error, stackTrace) => Text(error.toString()),
        loading:
            widget.loading ??
            () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class MovieView extends ConsumerWidget {
  const MovieView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(popularProvider()).value ?? [];
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final movie = data[index];
        return MovieItemView(key: ObjectKey(movie), movie: movie);
      },
    );
  }
}

class MovieItemView extends StatelessWidget {
  const MovieItemView({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => MovieDetailsRoute(movie: movie).push(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                createRectTween:  (begin, end) => MaterialRectArcTween(begin: begin, end: end),
                // placeholderBuilder: (context, size, child) => ClipRRect(
                //   borderRadius: BorderRadius.circular(size.height),
                //   child: child,
                // ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: Text(movie.title, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
