import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/add_story.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/story_repository_test.mocks.dart';

void main() {
  late AddStoryUseCase useCase;
  late MockStoryRepository mockStoryRepository;

  setUp(() {
    mockStoryRepository = MockStoryRepository();
    useCase = AddStoryUseCase(mockStoryRepository);
  });

  const tStory = Story(
    id: '1',
    title: 'Amazing Adventure',
    content: 'Once upon a time, there was an amazing adventure...',
    genre: StoryGenre.adventure,
    url: 'https://example.com/story/1',
    episode: 1,
    season: 1,
  );

  group('AddStoryUseCase', () {
    test('should call addStory on the repository', () async {
      when(mockStoryRepository.addStory(any))
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase(tStory);

      expect(result, const Right(unit));
      verify(mockStoryRepository.addStory(tStory)).called(1);
      verifyNoMoreInteractions(mockStoryRepository);
    });

    test('should return a ServerError when adding story fails', () async {
      final failure = ServerFailure(message: 'Failed to add story');

      when(mockStoryRepository.addStory(any))
          .thenAnswer((_) async => Left(failure));

      final result = await useCase(tStory);

      expect(result, Left(failure));
      verify(mockStoryRepository.addStory(tStory)).called(1);
      verifyNoMoreInteractions(mockStoryRepository);
    });
  });
}
