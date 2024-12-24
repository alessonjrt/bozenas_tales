import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/repositories/story_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStoryUseCase {
  final StoryRepository _repository;

  UpdateStoryUseCase(this._repository);

  Future<Either<Failure, Unit>> call(Story story) async {
    return await _repository.updateStory(story);
  }
}
