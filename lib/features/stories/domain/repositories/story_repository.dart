import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:dartz/dartz.dart';

abstract class StoryRepository {
  Future<Either<Failure, Unit>> addStory(Story story);
  Future<Either<Failure, List<Story>>> getStories({List<StoryGenre> genres});
  Future<Either<Failure, Unit>> updateStory(Story story);
  Future<Either<Failure, Unit>> deleteStory(String id);
}
