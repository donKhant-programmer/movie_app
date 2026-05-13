import 'package:flutter/material.dart';

import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<MovieModel> movies = [];

  MovieDetailModel? selectedMovie;

  bool isLoading = false;

  bool isLoadingMore = false;

  String errorMessage = '';

  int currentPage = 1;

  bool hasMore = true;

  String currentQuery = '';

  Future<void> searchMovies(String query) async {
    try {
      isLoading = true;
      errorMessage = '';
      currentPage = 1;
      hasMore = true;
      currentQuery = query;

      notifyListeners();

      final result = await _movieService.searchMovies(
        query: query,
        page: currentPage,
      );

      movies = result;

      if (result.isEmpty) {
        hasMore = false;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMovies() async {
    if (isLoadingMore || !hasMore) return;

    try {
      isLoadingMore = true;

      notifyListeners();

      currentPage++;

      final result = await _movieService.searchMovies(
        query: currentQuery,
        page: currentPage,
      );

      if (result.isEmpty) {
        hasMore = false;
      } else {
        movies.addAll(result);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchMovieDetail(String imdbId) async {
    try {
      isLoading = true;
      errorMessage = '';

      notifyListeners();

      selectedMovie = await _movieService.getMovieDetail(imdbId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedMovie() {
    selectedMovie = null;
  }
}
