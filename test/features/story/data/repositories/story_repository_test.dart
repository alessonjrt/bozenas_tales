import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/data/datasources/story_datasource.dart';
import 'package:bozenas_tales/features/stories/data/models/story_model.dart';
import 'package:bozenas_tales/features/stories/data/repositories/story_repository_impl.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'story_repository_test.mocks.dart';

@GenerateMocks([StoryDataSource])
void main() {
  late StoryRepositoryImpl repository;
  late MockStoryDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockStoryDataSource();
    repository = StoryRepositoryImpl(mockDataSource);
  });

  const tStoryModel = StoryModel(
    id: '1',
    title: 'Amazing Adventure',
    content: 'Once upon a time...',
    genre: StoryGenre.adventure,
    url: 'https://example.com/story/1',
    episode: 1,
    season: 1,
  );

  const anotherStoryModel = StoryModel(
    id: '2',
    title: 'Mystery Manor',
    content: 'In a dark mansion...',
    genre: StoryGenre.mystery,
    url: 'https://example.com/story/2',
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

  const anotherStory = Story(
    id: '2',
    title: 'Mystery Manor',
    content: 'In a dark mansion...',
    genre: StoryGenre.mystery,
    url: 'https://example.com/story/2',
    episode: 1,
    season: 1,
  );

  group('addStory', () {
    test('should return Unit when the data source adds the story successfully',
        () async {
      when(mockDataSource.addStory(any))
          .thenAnswer((_) async => const Right(unit));

      final result = await repository.addStory(tStory);

      expect(result, const Right(unit));
      verify(mockDataSource.addStory(tStoryModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return DatabaseFailure when adding a story fails', () async {
      when(mockDataSource.addStory(any))
          .thenAnswer((_) async => Left(DatabaseFailure(message: 'Error')));

      final result = await repository.addStory(tStory);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Expected a failure'),
      );
      verify(mockDataSource.addStory(tStoryModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('deleteStory', () {
    test(
        'should return Unit when the data source deletes the story successfully',
        () async {
      when(mockDataSource.deleteStory('1'))
          .thenAnswer((_) async => const Right(unit));

      final result = await repository.deleteStory('1');

      expect(result, const Right(unit));
      verify(mockDataSource.deleteStory('1')).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return DatabaseFailure when deleting a story fails', () async {
      when(mockDataSource.deleteStory('1'))
          .thenAnswer((_) async => Left(DatabaseFailure(message: 'Error')));

      final result = await repository.deleteStory('1');

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Expected a failure'),
      );
      verify(mockDataSource.deleteStory('1')).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('getStories', () {
    test(
        'should return a list of stories when the data source fetches them successfully',
        () async {
      when(mockDataSource.getStories()).thenAnswer(
          (_) async => const Right([tStoryModel, anotherStoryModel]));

      final result = await repository.getStories();

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Expected a list of stories'),
        (stories) {
          expect(stories.length, 2);
          expect(stories, containsAll([tStory, anotherStory]));
        },
      );
      verify(mockDataSource.getStories()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return filtered list of stories based on genres', () async {
      when(mockDataSource.getStories()).thenAnswer(
          (_) async => const Right([tStoryModel, anotherStoryModel]));

      final result =
          await repository.getStories(genres: [StoryGenre.adventure]);

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Expected a list of filtered stories'),
        (stories) {
          expect(stories.length, 1);
          expect(stories.first.genre, StoryGenre.adventure);
        },
      );
      verify(mockDataSource.getStories()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return all stories when genres is null', () async {
      when(mockDataSource.getStories()).thenAnswer(
          (_) async => const Right([tStoryModel, anotherStoryModel]));

      final result = await repository.getStories();

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Expected a list of all stories'),
        (stories) {
          expect(stories.length, 2);
          expect(stories, containsAll([tStory, anotherStory]));
        },
      );
      verify(mockDataSource.getStories()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return DatabaseFailure when fetching stories fails', () async {
      when(mockDataSource.getStories())
          .thenAnswer((_) async => Left(DatabaseFailure(message: 'Error')));

      final result = await repository.getStories();

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Expected a failure'),
      );
      verify(mockDataSource.getStories()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('updateStory', () {
    test(
        'should return Unit when the data source updates the story successfully',
        () async {
      when(mockDataSource.updateStory(any))
          .thenAnswer((_) async => const Right(unit));

      final result = await repository.updateStory(tStory);

      expect(result, const Right(unit));
      verify(mockDataSource.updateStory(tStoryModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return DatabaseFailure when updating a story fails', () async {
      when(mockDataSource.updateStory(any))
          .thenAnswer((_) async => Left(DatabaseFailure(message: 'Error')));

      final result = await repository.updateStory(tStory);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Expected a failure'),
      );
      verify(mockDataSource.updateStory(tStoryModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
