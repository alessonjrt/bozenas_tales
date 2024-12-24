import 'package:bozenas_tales/features/stories/data/models/story_model.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tStoryModel = StoryModel(
    id: '1',
    title: 'Amazing Adventure',
    content: 'Once upon a time...',
    genre: StoryGenre.adventure,
    url: 'https://example.com/story/1',
    episode: 1,
    season: 1,
  );

  const tStory = Story(
    id: '1',
    title: 'Amazing Adventure',
    content: 'Once upon a time...',
    genre: StoryGenre.adventure,
    url: 'https://example.com/story/1',
    episode: 1,
    season: 1,
  );

  group('StoryModel', () {
    group('fromJson', () {
      test('should return a valid StoryModel when JSON is valid', () {
        final jsonMap = {
          'id': '1',
          'title': 'Amazing Adventure',
          'content': 'Once upon a time...',
          'genre': 'adventure',
          'url': 'https://example.com/story/1',
          'episode': 1,
          'season': 1,
        };

        final result = StoryModel.fromJson(jsonMap);

        expect(result, tStoryModel);
      });

      test('should throw ArgumentError when genre is unknown', () {
        final jsonMap = {
          'id': '2',
          'title': 'Unknown Genre Story',
          'content': 'Content...',
          'genre': 'unknown_genre',
          'url': 'https://example.com/story/2',
          'episode': 1,
          'season': 1,
        };

        expect(
            () => StoryModel.fromJson(jsonMap), throwsA(isA<ArgumentError>()));
      });

      test('should throw a TypeError when a field has an invalid type', () {
        final jsonMap = {
          'id': '3',
          'title': 'Invalid Type Story',
          'content': 'Content...',
          'genre': 'drama',
          'url': 'https://example.com/story/3',
          'episode': 'one',
          'season': 1,
        };

        expect(() => StoryModel.fromJson(jsonMap), throwsA(isA<TypeError>()));
      });

      test('should throw a NoSuchMethodError when a required field is missing',
          () {
        final jsonMap = {
          'id': '4',
          'content': 'Content...',
          'genre': 'comedy',
          'url': 'https://example.com/story/4',
          'episode': 1,
          'season': 1,
        };

        expect(() => StoryModel.fromJson(jsonMap), throwsA(isA<TypeError>()));
      });
    });

    group('toJson', () {
      test('should return JSON map containing the proper data', () {
        final result = tStoryModel.toJson();

        final expectedJsonMap = {
          'id': '1',
          'title': 'Amazing Adventure',
          'content': 'Once upon a time...',
          'genre': 'adventure',
          'url': 'https://example.com/story/1',
          'episode': 1,
          'season': 1,
        };
        expect(result, expectedJsonMap);
      });
    });

    group('toEntity', () {
      test('should return a valid Story entity', () {
        final result = tStoryModel.toEntity();

        expect(result, tStory);
      });
    });

    group('fromEntity', () {
      test('should return a StoryModel from a Story entity', () {
        final result = StoryModel.fromEntity(tStory);

        expect(result, tStoryModel);
      });
    });

    group('Equatable', () {
      test('should be equal to another StoryModel with the same properties',
          () {
        const anotherStoryModel = StoryModel(
          id: '1',
          title: 'Amazing Adventure',
          content: 'Once upon a time...',
          genre: StoryGenre.adventure,
          url: 'https://example.com/story/1',
          episode: 1,
          season: 1,
        );

        expect(tStoryModel, anotherStoryModel);
      });

      test(
          'should not be equal to another StoryModel with different properties',
          () {
        const differentStoryModel = StoryModel(
          id: '2',
          title: 'Different Story',
          content: 'Different content...',
          genre: StoryGenre.drama,
          url: 'https://example.com/story/2',
          episode: 2,
          season: 1,
        );

        expect(tStoryModel, isNot(differentStoryModel));
      });
    });
  });
}
