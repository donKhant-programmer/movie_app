import 'package:flutter/material.dart';
import 'package:movie_app/core/constants/app_colors.dart';

class MovieSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const MovieSearchField({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => onSearch(),
      decoration: InputDecoration(
        hintText: 'Search movies...',
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
