import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:bozenas_tales/features/stories/domain/repositories/story_repository.dart';
import 'package:dartz/dartz.dart';

class GetStoriesUseCase {
  final StoryRepository _repository;

  GetStoriesUseCase(this._repository);

  Future<Either<Failure, List<Story>>> call(
      {List<StoryGenre> genres = const []}) async {
    return await _repository.getStories(genres: genres);
  }
}
