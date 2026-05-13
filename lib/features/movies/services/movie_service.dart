import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';

class MovieService {
  Future<List<MovieModel>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final Response response = await DioClient.dio.get(
        '',
        queryParameters: {
          'apikey': ApiConstants.apiKey,
          's': query,
          'page': page,
        },
      );

      final data = response.data;

      if (data['Response'] == 'True') {
        final List movies = data['Search'];

        return movies.map((movie) => MovieModel.fromJson(movie)).toList();
      } else {
        throw Exception(data['Error'] ?? 'Something went wrong');
      }
    } catch (e) {
      print('Failed to fetch movies $e');
      throw Exception('Failed to fetch movies $e');
    }
  }

  Future<MovieDetailModel> getMovieDetail(String imdbId) async {
    try {
      final Response response = await DioClient.dio.get(
        '',
        queryParameters: {
          'apikey': ApiConstants.apiKey,
          'i': imdbId,
          'plot': 'full',
        },
      );

      final data = response.data;

      if (data['Response'] == 'True') {
        return MovieDetailModel.fromJson(data);
      } else {
        throw Exception(data['Error'] ?? 'Something went wrong');
      }
    } catch (e) {
      throw Exception('Failed to fetch movie detail');
    }
  }
}
