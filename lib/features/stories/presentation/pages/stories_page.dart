import 'package:bozenas_tales/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:bozenas_tales/features/stories/presentation/widgets/bozena.dart';
import 'package:bozenas_tales/features/stories/presentation/widgets/filters_row.dart';
import 'package:bozenas_tales/features/stories/presentation/widgets/story_form.dart';
import 'package:bozenas_tales/features/stories/presentation/widgets/story_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoriesListPage extends StatefulWidget {
  final StoriesCubit storiesCubit;
  const StoriesListPage({super.key, required this.storiesCubit});

  @override
  State<StoriesListPage> createState() => _StoriesListPageState();
}

class _StoriesListPageState extends State<StoriesListPage> {
  @override
  void initState() {
    super.initState();
    widget.storiesCubit.fetchStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Bozena(
              height: 70,
            ),
            Text('Histórias da Bozena'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FA), Color(0xFFECECEC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocBuilder<StoriesCubit, StoriesState>(
          bloc: widget.storiesCubit,
          builder: (context, state) {
            if (state is StoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StoriesLoaded) {
              final stories = state.stories;
              final selectedGenres = state.selectedGenres;
              return Column(
                children: [
                  FiltersRow(
                    selectedGenres: selectedGenres,
                    onSelected: (value, genre) {
                      final newGenres = [...selectedGenres];
                      if (value) {
                        newGenres.add(genre);
                      } else {
                        newGenres.remove(genre);
                      }
                      widget.storiesCubit.updateFilters(newGenres);
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: stories.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhuma história encontrada.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            itemCount: stories.length,
                            itemBuilder: (context, index) {
                              final story = stories[index];
                              return StoryItem(
                                story: story,
                                onTap: () async {
                                  final result = await showStoryForm(
                                    context: context,
                                    story: story,
                                  );
                                  if (result != null) {
                                    widget.storiesCubit.updateStory(result);
                                  }
                                },
                                onDelete: () =>
                                    widget.storiesCubit.deleteStory(story.id),
                              );
                            },
                          ),
                  ),
                ],
              );
            } else if (state is StoriesError) {
              return Center(
                child: Text(
                  'Erro: ${state.message}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            }
            return Center(
              child: Text(
                'Bem-vindo(a) às Histórias da Bozena!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showStoryForm(context: context);
          if (result != null) {
            widget.storiesCubit.addStory(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
