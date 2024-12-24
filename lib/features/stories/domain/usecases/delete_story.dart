import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/domain/repositories/story_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteStoryUseCase {
  final StoryRepository repository;

  DeleteStoryUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteStory(id);
  }
}
