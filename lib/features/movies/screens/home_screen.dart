import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../screens/movie_detail_screen.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
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

    if (currentScroll >= maxScroll * 0.8) {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: MovieSearchField(
              controller: _searchController,
              onSearch: _searchMovies,
            ),
          ),

          Expanded(
            child: Builder(
              builder: (_) {
                /// INITIAL EMPTY
                if (provider.movies.isEmpty &&
                    !provider.isLoading &&
                    provider.errorMessage.isEmpty) {
                  return const Center(child: Text('Search movies to begin'));
                }

                /// LOADING
                if (provider.isLoading && provider.movies.isEmpty) {
                  return const LoadingWidget();
                }

                /// ERROR
                if (provider.errorMessage.isNotEmpty &&
                    provider.movies.isEmpty) {
                  return CustomErrorWidget(message: provider.errorMessage);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.searchMovies(provider.currentQuery);
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount:
                        provider.movies.length +
                        (provider.isLoadingMore ? 1 : 0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder: (context, index) {
                      /// PAGINATION LOADER
                      if (index >= provider.movies.length) {
                        return const LoadingWidget();
                      }

                      final movie = provider.movies[index];

                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          context.read<MovieProvider>().clearSelectedMovie();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MovieDetailScreen(imdbId: movie.imdbId),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
