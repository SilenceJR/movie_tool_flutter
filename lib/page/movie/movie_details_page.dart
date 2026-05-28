

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_tool/provider/tmdb_provider.dart';

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key, this.id, this.movie});

  final String? id;
  final Movie? movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Hero(
              tag: 'https://image.tmdb.org/t/p/w500${movie?.posterPath}',
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie?.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie?.title ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    movie?.overview ?? '',
                  ),
                  Text(
                    'Release Date: ${movie?.releaseDate}',
                  ),
                  Text( 'Rating: ${movie?.voteAverage}'),
                  LinearProgressIndicator(
                    value: (movie?.voteAverage??0)/10,
                  )
                ]
              )
            )
          )
        ],
      ),
    );
  }
}
