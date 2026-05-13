import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  final String imdbId;

  const MovieDetailScreen({super.key, required this.imdbId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MovieProvider>().fetchMovieDetail(widget.imdbId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();

    final movie = provider.selectedMovie;

    return Scaffold(
      body: provider.isLoading
          ? const LoadingWidget()
          : provider.errorMessage.isNotEmpty
          ? CustomErrorWidget(message: provider.errorMessage)
          : movie == null
          ? const Center(child: Text('No data found'))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: Image.network(
                      movie.poster,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image);
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Year", movie.year),
                        _infoRow("Genre", movie.genre),
                        _infoRow("Director", movie.director),
                        _infoRow("Actors", movie.actors),
                        _infoRow("Rating", movie.imdbRating),
                        const SizedBox(height: 20),
                        const Text(
                          "Plot",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(movie.plot, style: const TextStyle(height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
