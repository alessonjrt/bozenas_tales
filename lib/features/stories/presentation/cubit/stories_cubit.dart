import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/add_story.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/delete_story.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/get_stories.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/update_story.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final GetStoriesUseCase getStoriesUseCase;
  final AddStoryUseCase addStoryUseCase;
  final UpdateStoryUseCase updateStoryUseCase;
  final DeleteStoryUseCase deleteStoryUseCase;

  StoriesCubit({
    required this.getStoriesUseCase,
    required this.addStoryUseCase,
    required this.updateStoryUseCase,
    required this.deleteStoryUseCase,
  }) : super(StoriesInitial());

  Future<void> fetchStories({List<StoryGenre> genres = const []}) async {
    emit(StoriesLoading());

    final result = await getStoriesUseCase(genres: genres);

    result.fold(
      (failure) => emit(StoriesError(message: failure.message)),
      (stories) {
        emit(
          StoriesLoaded(
            stories: stories,
            selectedGenres: genres, // Armazena os filtros usados
          ),
        );
      },
    );
  }

  Future<void> addStory(Story story) async {
    emit(StoriesLoading());

    final result = await addStoryUseCase(story);

    result.fold(
      (failure) => emit(StoriesError(message: failure.message)),
      (_) => _reloadStories(),
    );
  }

  Future<void> updateStory(Story story) async {
    emit(StoriesLoading());

    final result = await updateStoryUseCase(story);

    result.fold(
      (failure) => emit(StoriesError(message: failure.message)),
      (_) => _reloadStories(),
    );
  }

  Future<void> deleteStory(String storyId) async {
    emit(StoriesLoading());

    final result = await deleteStoryUseCase(storyId);

    result.fold(
      (failure) => emit(StoriesError(message: failure.message)),
      (_) => _reloadStories(),
    );
  }

  Future<void> _reloadStories() async {
    if (state is StoriesLoaded) {
      final currentGenres = (state as StoriesLoaded).selectedGenres;
      await fetchStories(genres: currentGenres);
    } else {
      await fetchStories();
    }
  }

  void updateFilters(List<StoryGenre> newGenres) {
    fetchStories(genres: newGenres);
  }
}
