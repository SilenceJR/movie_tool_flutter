import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_tool/provider/tmdb_provider.dart';
import 'package:movie_tool/util/log.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int page = 1;

  @override
  void initState() {
    super.initState();
    // getData();
  }

  Future<void> getData({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
    }
    await ref.read(popularProvider.notifier).getData(page: page);
  }

  @override
  Widget build(BuildContext context) {
    final popular = ref.watch(popularProvider);
    logD('build');
    return Scaffold(
      body: EasyRefresh(
        refreshOnStart: true,
        onRefresh: () => getData(isRefresh: true),
        onLoad: getData,
        child: popular.when(
          data: (data) {
            page++;
            logD('popular:$data');
            // return Text(data.toString());
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
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          fit: BoxFit.cover,
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
                          child: Text(
                            movie.title,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
