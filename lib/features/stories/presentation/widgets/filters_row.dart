import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:flutter/material.dart';

class FiltersRow extends StatelessWidget {
  final List<StoryGenre> selectedGenres;
  final void Function(bool, StoryGenre)? onSelected;
  const FiltersRow(
      {super.key, required this.selectedGenres, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: StoryGenre.values.map((genre) {
          final isSelected = selectedGenres.contains(genre);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(genre.name),
              selected: isSelected,
              onSelected: (value) => onSelected?.call(value, genre),
            ),
          );
        }).toList(),
      ),
    );
  }
}
