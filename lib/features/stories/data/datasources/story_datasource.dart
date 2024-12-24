import 'package:bozenas_tales/core/failure.dart';
import 'package:dartz/dartz.dart';

import '../models/story_model.dart';

abstract class StoryDataSource {
  Future<Either<Failure, Unit>> addStory(StoryModel storyModel);

  Future<Either<Failure, List<StoryModel>>> getStories();

  Future<Either<Failure, Unit>> updateStory(StoryModel storyModel);

  Future<Either<Failure, Unit>> deleteStory(String id);
}
