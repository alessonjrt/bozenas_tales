import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/data/datasources/story_datasource_impl.dart';
import 'package:bozenas_tales/features/stories/data/models/story_model.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../injection/injection_container.dart';

void main() {
  late StoryLocalDataSource dataSource;

  setUpAll(() async {
    await setupLocator();
    dataSource = getItTest<StoryLocalDataSource>();
  });

  tearDownAll(() async {
    await dataSource.close();
    await teardownLocator();
  });

  group('StoryLocalDataSource Tests', () {
    test('Should add a story to the database successfully', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final story = StoryModel(
        id: timestamp,
        title: 'Test Story',
        content: 'This is a test story.',
        genre: StoryGenre.fantasy,
        url: 'http://example.com/story',
        episode: 1,
        season: 1,
      );

      await dataSource.addStory(story);

      final storiesResult = await dataSource.getStories();
      expect(storiesResult.isRight(), true);
      storiesResult.fold(
        (failure) => fail('Expected to retrieve stories, but received failure'),
        (stories) {
          expect(stories.length, greaterThan(0));
          expect(stories.last, story);
        },
      );
    });

    test('Should return a list of stories from the database', () async {
      final timestamp1 = DateTime.now().millisecondsSinceEpoch.toString();
      final story1 = StoryModel(
        id: timestamp1,
        title: 'Story One',
        content: 'Content One',
        genre: StoryGenre.sciFi,
        url: 'http://example.com/story1',
        episode: 1,
        season: 1,
      );

      await Future.delayed(const Duration(milliseconds: 1));

      final timestamp2 = DateTime.now().millisecondsSinceEpoch.toString();
      final story2 = StoryModel(
        id: timestamp2,
        title: 'Story Two',
        content: 'Content Two',
        genre: StoryGenre.horror,
        url: 'http://example.com/story2',
        episode: 2,
        season: 1,
      );

      await dataSource.addStory(story1);
      await dataSource.addStory(story2);

      final result = await dataSource.getStories();

      expect(result.isRight(), true);
      result.fold(
        (failure) =>
            fail('Expected to retrieve story list, but received failure'),
        (stories) {
          expect(stories, containsAll([story1, story2]));
        },
      );
    });

    test('Should update an existing story in the database', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final story = StoryModel(
        id: timestamp,
        title: 'Original Title',
        content: 'Original Content',
        genre: StoryGenre.drama,
        url: 'http://example.com/story',
        episode: 1,
        season: 1,
      );

      await dataSource.addStory(story);

      final updatedStory = StoryModel(
        id: story.id,
        title: 'Updated Title',
        content: 'Updated Content',
        genre: StoryGenre.mystery,
        url: 'http://example.com/story',
        episode: 2,
        season: 1,
      );

      final result = await dataSource.updateStory(updatedStory);

      expect(result, const Right(unit));

      final storiesResult = await dataSource.getStories();
      expect(storiesResult.isRight(), true);
      storiesResult.fold(
        (failure) => fail('Expected to retrieve stories, but received failure'),
        (stories) {
          final found =
              stories.firstWhere((story) => story.id == updatedStory.id);

          expect(found.title, 'Updated Title');
          expect(found.content, 'Updated Content');
          expect(found.genre, StoryGenre.mystery);
          expect(found.episode, 2);
        },
      );
    });

    test('Should delete an existing story from the database', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final story = StoryModel(
        id: timestamp,
        title: 'Story to Delete',
        content: 'Content to Delete',
        genre: StoryGenre.mystery,
        url: 'http://example.com/story',
        episode: 1,
        season: 1,
      );

      await dataSource.addStory(story);

      final result = await dataSource.deleteStory(story.id);

      expect(result, const Right(unit));
    });

    test('Should return DatabaseFailure when updating a non-existent story',
        () async {
      const nonExistentStory = StoryModel(
        id: 'non-existent-id',
        title: 'Non-existent',
        content: 'Does not exist',
        genre: StoryGenre.adventure,
        url: 'http://example.com/nonexistent',
        episode: 0,
        season: 0,
      );

      final result = await dataSource.updateStory(nonExistentStory);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Expected DatabaseFailure, but received success'),
      );
    });

    test('Should return DatabaseFailure when deleting a non-existent story',
        () async {
      final result = await dataSource.deleteStory('non-existent-id');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Expected DatabaseFailure, but received success'),
      );
    });
  });
}
