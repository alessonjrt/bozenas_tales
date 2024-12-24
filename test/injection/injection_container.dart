import 'package:bozenas_tales/features/stories/data/datasources/story_datasource_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final getItTest = GetIt.instance;

Future<void> setupLocator() async {
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  getItTest.registerSingletonAsync<StoryLocalDataSource>(
    () async => await StoryLocalDataSource().init(),
  );

  await getItTest.allReady();
}

Future<void> teardownLocator() async {
  await getItTest.reset();
}
