import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/data/datasources/story_datasource.dart';
import 'package:bozenas_tales/features/stories/data/models/story_model.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:bozenas_tales/features/stories/domain/repositories/story_repository.dart';
import 'package:dartz/dartz.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryDataSource dataSource;

  StoryRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Unit>> addStory(Story story) async {
    try {
      final storyModel = StoryModel.fromEntity(story);
      final result = await dataSource.addStory(storyModel);
      return result;
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao adicionar história: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteStory(String id) async {
    try {
      final result = await dataSource.deleteStory(id);
      return result;
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao deletar história: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getStories(
      {List<StoryGenre>? genres}) async {
    try {
      final result = await dataSource.getStories();
      return result.fold(
        (failure) => Left(failure),
        (storyModels) {
          List<Story> stories =
              storyModels.map((model) => model.toEntity()).toList();
          if (genres != null && genres.isNotEmpty) {
            stories =
                stories.where((story) => genres.contains(story.genre)).toList();
          }
          return Right(stories);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao buscar histórias: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStory(Story story) async {
    try {
      final storyModel = StoryModel.fromEntity(story);
      final result = await dataSource.updateStory(storyModel);
      return result;
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao atualizar história: $e'));
    }
  }
}
