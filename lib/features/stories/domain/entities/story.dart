import 'package:equatable/equatable.dart';

import '../enums/story_genre.dart';

class Story extends Equatable {
  final String id;
  final String title;
  final String content;
  final StoryGenre genre;
  final String url;
  final int episode;
  final int season;

  const Story({
    required this.id,
    required this.title,
    required this.content,
    required this.genre,
    required this.url,
    required this.episode,
    required this.season,
  });

  @override
  List<Object?> get props => [id, title, content, genre, url, episode, season];
}
