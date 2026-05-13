import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/constants/app_colors.dart';
import 'package:movie_app/features/movies/models/movie_detail_model.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
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
      body: movie == null && provider.isLoading
          ? _buildLoadingState()
          : provider.errorMessage.isNotEmpty
          ? CustomErrorWidget(message: provider.errorMessage)
          : movie == null
          ? const Center(child: Text('No data found'))
          : _buildContent(movie),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          backgroundColor: AppColors.background,
          flexibleSpace: Container(
            color: AppColors.surface,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.skeleton,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(MovieDetailModel movie) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,

            titlePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),

            title: Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 10, color: AppColors.shadow)],
              ),
            ),

            background: Stack(
              fit: StackFit.expand,
              children: [
                /// IMAGE
                CachedNetworkImage(
                  imageUrl: movie.poster,
                  fit: BoxFit.cover,

                  placeholder: (context, url) => Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()),
                  ),

                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.movie,
                      color: AppColors.textSecondary,
                      size: 60,
                    ),
                  ),
                ),

                /// DARK OVERLAY
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x88000000),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SafeArea(
            top: false,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(movie.plot, style: const TextStyle(height: 1.5)),
                ],
              ),
            ),
          ),
        ),
      ],
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
