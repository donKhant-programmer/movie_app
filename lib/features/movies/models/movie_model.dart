class MovieModel {
  final String imdbId;
  final String title;
  final String year;
  final String poster;
  final String type;

  MovieModel({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbId: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] ?? '',
      type: json['Type'] ?? '',
    );
  }
}
