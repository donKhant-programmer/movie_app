import 'package:flutter/material.dart';
import 'package:movie_app/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../screens/movie_detail_screen.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final provider = context.read<MovieProvider>();

    final maxScroll = _scrollController.position.maxScrollExtent;

    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.8 &&
        !provider.isLoadingMore &&
        provider.hasMore) {
      provider.loadMoreMovies();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _searchMovies() {
    FocusScope.of(context).unfocus();

    final query = _searchController.text.trim();

    if (query.isEmpty) return;

    context.read<MovieProvider>().searchMovies(query);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();

    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;

    if (width > 900) {
      crossAxisCount = 5;
    } else if (width > 700) {
      crossAxisCount = 4;
    } else if (width > 500) {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Movie App'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: MovieSearchField(
                controller: _searchController,
                onSearch: _searchMovies,
              ),
            ),

            Expanded(
              child: provider.movies.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_creation_outlined,
                              size: 72,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Search Movies',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'Find your favorite movies, and series instantly.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            await provider.searchMovies(provider.currentQuery);
                          },
                          child: GridView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                            itemCount: provider.movies.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.62,
                                ),
                            itemBuilder: (context, index) {
                              final movie = provider.movies[index];

                              return MovieCard(
                                movie: movie,
                                onTap: () {
                                  context
                                      .read<MovieProvider>()
                                      .clearSelectedMovie();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MovieDetailScreen(
                                        imdbId: movie.imdbId,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        /// BOTTOM PAGINATION LOADER
                        if (provider.isLoadingMore)
                          const Positioned(
                            left: 0,
                            right: 0,
                            bottom: 16,
                            child: Center(
                              child: SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
