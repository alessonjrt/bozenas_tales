// lib/features/stories/data/models/story_model.dart

import 'package:equatable/equatable.dart';

import '../../domain/entities/story.dart';
import '../../domain/enums/story_genre.dart';

class StoryModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final StoryGenre genre;
  final String url;
  final int episode;
  final int season;

  const StoryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.genre,
    required this.url,
    required this.episode,
    required this.season,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      genre: _stringToGenre(json['genre']),
      url: json['url'],
      episode: json['episode'],
      season: json['season'],
    );
  }

  Story toEntity() {
    return Story(
      id: id,
      title: title,
      content: content,
      genre: genre,
      url: url,
      episode: episode,
      season: season,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'genre': _genreToString(genre),
      'url': url,
      'episode': episode,
      'season': season,
    };
  }

  static StoryGenre _stringToGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'comedy':
        return StoryGenre.comedy;
      case 'drama':
        return StoryGenre.drama;
      case 'horror':
        return StoryGenre.horror;
      case 'adventure':
        return StoryGenre.adventure;
      case 'romance':
        return StoryGenre.romance;
      case 'fantasy':
        return StoryGenre.fantasy;
      case 'sci-fi':
      case 'scifi':
        return StoryGenre.sciFi;
      case 'mystery':
        return StoryGenre.mystery;
      default:
        throw ArgumentError('Unknown genre: $genre');
    }
  }

  static String _genreToString(StoryGenre genre) {
    switch (genre) {
      case StoryGenre.comedy:
        return 'comedy';
      case StoryGenre.drama:
        return 'drama';
      case StoryGenre.horror:
        return 'horror';
      case StoryGenre.adventure:
        return 'adventure';
      case StoryGenre.romance:
        return 'romance';
      case StoryGenre.fantasy:
        return 'fantasy';
      case StoryGenre.sciFi:
        return 'sci-fi';
      case StoryGenre.mystery:
        return 'mystery';
    }
  }

  factory StoryModel.fromEntity(Story story) {
    return StoryModel(
      id: story.id,
      title: story.title,
      content: story.content,
      genre: story.genre,
      url: story.url,
      episode: story.episode,
      season: story.season,
    );
  }

  @override
  List<Object?> get props => [id, title, content, genre, url, episode, season];
}
