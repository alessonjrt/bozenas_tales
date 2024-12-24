import 'package:bloc_test/bloc_test.dart';
import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:bozenas_tales/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:bozenas_tales/features/stories/presentation/pages/stories_page.dart';
import 'package:bozenas_tales/features/stories/presentation/widgets/story_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStoriesCubit extends MockCubit<StoriesState>
    implements StoriesCubit {}

class FakeStoriesInitial extends Fake implements StoriesInitial {}

class FakeStoriesLoading extends Fake implements StoriesLoading {}

class FakeStoriesLoaded extends Fake implements StoriesLoaded {}

class FakeStoriesError extends Fake implements StoriesError {}

class FakeStory extends Fake implements Story {}

void main() {
  late MockStoriesCubit mockStoriesCubit;

  setUpAll(() {
    registerFallbackValue(FakeStoriesInitial());
    registerFallbackValue(FakeStoriesLoading());
    registerFallbackValue(FakeStoriesLoaded());
    registerFallbackValue(FakeStoriesError());
    registerFallbackValue(FakeStory());
  });

  setUp(() {
    mockStoriesCubit = MockStoriesCubit();
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: BlocProvider<StoriesCubit>.value(
        value: mockStoriesCubit,
        child: widget,
      ),
    );
  }

  group('StoriesListPage', () {
    final stories = [
      const Story(
        id: '1',
        title: 'História 1',
        genre: StoryGenre.fantasy,
        content: 'Este é o conteúdo da história 1.',
        url: 'https://exemplo.com/historia1',
        episode: 1,
        season: 1,
      ),
      const Story(
        id: '2',
        title: 'História 2',
        genre: StoryGenre.horror,
        content: 'Este é o conteúdo da história 2.',
        url: 'https://exemplo.com/historia2',
        episode: 2,
        season: 1,
      ),
    ];

    testWidgets('Shows loading indicator when the screen opens',
        (tester) async {
      when(() => mockStoriesCubit.state).thenReturn(StoriesLoading());
      when(() => mockStoriesCubit.fetchStories()).thenAnswer((_) async {});
      await tester.pumpWidget(
          buildTestableWidget(StoriesListPage(storiesCubit: mockStoriesCubit)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => mockStoriesCubit.fetchStories()).called(1);
    });

    testWidgets('Displays a list of stories when there are stories',
        (tester) async {
      when(() => mockStoriesCubit.state).thenReturn(
        StoriesLoaded(stories: stories, selectedGenres: const []),
      );
      when(() => mockStoriesCubit.fetchStories()).thenAnswer((_) async {});
      await tester.pumpWidget(
          buildTestableWidget(StoriesListPage(storiesCubit: mockStoriesCubit)));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(StoryItem), findsNWidgets(stories.length));
      for (var story in stories) {
        expect(find.text(story.title), findsOneWidget);
      }
    });

    testWidgets('Displays "No stories found." message when the list is empty',
        (tester) async {
      when(() => mockStoriesCubit.state).thenReturn(
        const StoriesLoaded(stories: [], selectedGenres: []),
      );
      when(() => mockStoriesCubit.fetchStories()).thenAnswer((_) async {});
      await tester.pumpWidget(
          buildTestableWidget(StoriesListPage(storiesCubit: mockStoriesCubit)));
      expect(find.text('Nenhuma história encontrada.'), findsOneWidget);
    });

    testWidgets('Displays an error message when an error occurs',
        (tester) async {
      const errorMessage = 'Falha ao carregar histórias.';
      when(() => mockStoriesCubit.state)
          .thenReturn(const StoriesError(message: errorMessage));
      when(() => mockStoriesCubit.fetchStories()).thenAnswer((_) async {});
      await tester.pumpWidget(
          buildTestableWidget(StoriesListPage(storiesCubit: mockStoriesCubit)));
      expect(find.text('Erro: $errorMessage'), findsOneWidget);
    });

    testWidgets(
        'Creates a new story when pressing the + button and saving the form',
        (tester) async {
      when(() => mockStoriesCubit.state).thenReturn(
        StoriesLoaded(stories: stories, selectedGenres: const []),
      );
      when(() => mockStoriesCubit.fetchStories()).thenAnswer((_) async {});
      when(() => mockStoriesCubit.addStory(any())).thenAnswer((_) async {});
      await tester.pumpWidget(
          buildTestableWidget(StoriesListPage(storiesCubit: mockStoriesCubit)));
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();
    });

    testWidgets('Edits a story when tapping on the item and saving the form',
        (tester) async {
      when(() => mockStoriesCubit.state).thenReturn(
        StoriesLoaded(stories: stories, selectedGenres: const []),
      );
      when(() => mockStoriesCubit.fetchStories()).thenAnswer((_) async {});
      when(() => mockStoriesCubit.addStory(any())).thenAnswer((_) async {});
      await tester.pumpWidget(
          buildTestableWidget(StoriesListPage(storiesCubit: mockStoriesCubit)));
      final firstStoryItem = find.byType(StoryItem).first;
      await tester.tap(firstStoryItem);
      await tester.pumpAndSettle();
    });

    testWidgets('Deletes a story when pressing the delete button',
        (tester) async {
      when(() => mockStoriesCubit.state).thenReturn(
        StoriesLoaded(stories: stories, selectedGenres: const []),
      );
      when(() => mockStoriesCubit.fetchStories()).thenAnswer((_) async {});
      when(() => mockStoriesCubit.deleteStory(any())).thenAnswer((_) async {});
      await tester.pumpWidget(
          buildTestableWidget(StoriesListPage(storiesCubit: mockStoriesCubit)));
      final firstStoryItemDeleteFinder = find.descendant(
        of: find.byType(StoryItem).first,
        matching: find.byIcon(Icons.delete),
      );
      expect(firstStoryItemDeleteFinder, findsOneWidget);
      await tester.tap(firstStoryItemDeleteFinder);
      await tester.pumpAndSettle();
      verify(() => mockStoriesCubit.deleteStory('1')).called(1);
    });
  });
}
