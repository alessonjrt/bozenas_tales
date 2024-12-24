import 'package:bozenas_tales/core/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/story.dart';
import '../repositories/story_repository.dart';

class AddStoryUseCase {
  final StoryRepository repository;

  AddStoryUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Story story) async {
    return await repository.addStory(story);
  }
}
