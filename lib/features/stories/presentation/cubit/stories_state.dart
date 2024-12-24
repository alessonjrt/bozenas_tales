part of 'stories_cubit.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<Story> stories;
  // Adicione esta nova propriedade:
  final List<StoryGenre> selectedGenres;

  const StoriesLoaded({
    required this.stories,
    required this.selectedGenres,
  });

  @override
  List<Object> get props => [stories, selectedGenres];

  // Crie este método para facilitar a cópia do estado
  StoriesLoaded copyWith({
    List<Story>? stories,
    List<StoryGenre>? selectedGenres,
  }) {
    return StoriesLoaded(
      stories: stories ?? this.stories,
      selectedGenres: selectedGenres ?? this.selectedGenres,
    );
  }
}

class StoriesError extends StoriesState {
  final String message;

  const StoriesError({required this.message});

  @override
  List<Object> get props => [message];
}
