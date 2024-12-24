import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:bozenas_tales/features/stories/presentation/widgets/story_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Story Form: valid input should return a Story object',
      (WidgetTester tester) async {
    const testStory = Story(
      id: '1',
      title: 'Test Title',
      content: 'Test Content',
      genre: StoryGenre.fantasy,
      url: 'https://example.com',
      episode: 1,
      season: 1,
    );

    Story? returnedStory;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  final result =
                      await showStoryForm(context: context, story: null);
                  returnedStory = result;
                },
                child: const Text('Open Form'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Form'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), testStory.title);
    await tester.enterText(find.byType(TextFormField).at(1), testStory.content);

    final dropdownFinder = find.byType(DropdownButtonFormField<StoryGenre>);
    expect(dropdownFinder, findsOneWidget);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    final genreItemFinder = find.text('fantasy').last;
    expect(genreItemFinder, findsOneWidget);
    await tester.tap(genreItemFinder);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(2), testStory.url);
    await tester.enterText(
        find.byType(TextFormField).at(3), testStory.episode.toString());
    await tester.enterText(
        find.byType(TextFormField).at(4), testStory.season.toString());

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(returnedStory, isNotNull);
    expect(returnedStory?.title, equals(testStory.title));
    expect(returnedStory?.content, equals(testStory.content));
    expect(returnedStory?.genre, equals(testStory.genre));
    expect(returnedStory?.url, equals(testStory.url));
    expect(returnedStory?.episode, equals(testStory.episode));
    expect(returnedStory?.season, equals(testStory.season));
  });
}
