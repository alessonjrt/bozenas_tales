import 'dart:io';

import 'package:bozenas_tales/features/stories/data/datasources/story_datasource_impl.dart';
import 'package:bozenas_tales/features/stories/data/repositories/story_repository_impl.dart';
import 'package:bozenas_tales/features/stories/domain/repositories/story_repository.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/add_story.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/delete_story.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/get_stories.dart';
import 'package:bozenas_tales/features/stories/domain/usecases/update_story.dart';
import 'package:bozenas_tales/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  getIt.registerSingletonAsync<StoryLocalDataSource>(
    () async => await StoryLocalDataSource().init(),
  );

  getIt.registerLazySingleton<StoryRepository>(
    () => StoryRepositoryImpl(getIt<StoryLocalDataSource>()),
  );

  getIt.registerLazySingleton<GetStoriesUseCase>(
    () => GetStoriesUseCase(getIt<StoryRepository>()),
  );
  getIt.registerLazySingleton<AddStoryUseCase>(
    () => AddStoryUseCase(getIt<StoryRepository>()),
  );
  getIt.registerLazySingleton<UpdateStoryUseCase>(
    () => UpdateStoryUseCase(getIt<StoryRepository>()),
  );
  getIt.registerLazySingleton<DeleteStoryUseCase>(
    () => DeleteStoryUseCase(getIt<StoryRepository>()),
  );

  getIt.registerFactory<StoriesCubit>(
    () => StoriesCubit(
      getStoriesUseCase: getIt<GetStoriesUseCase>(),
      addStoryUseCase: getIt<AddStoryUseCase>(),
      updateStoryUseCase: getIt<UpdateStoryUseCase>(),
      deleteStoryUseCase: getIt<DeleteStoryUseCase>(),
    ),
  );

  await getIt.allReady();
}
