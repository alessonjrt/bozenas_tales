import 'dart:async';

import 'package:bozenas_tales/core/failure.dart';
import 'package:bozenas_tales/features/stories/data/datasources/story_datasource.dart';
import 'package:bozenas_tales/features/stories/data/models/story_model.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class StoryLocalDataSource implements StoryDataSource {
  static const String _databaseName = "stories.db";
  static const int _databaseVersion = 1;
  static const String table = 'stories';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await init();
    return _database!;
  }

  Future<StoryLocalDataSource> init() async {
    final dbPath = await getDatabasesPath();
    final fullDbPath = path.join(dbPath, _databaseName);

    _database = await openDatabase(fullDbPath,
        version: _databaseVersion, onCreate: _onCreate);

    return this;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            genre TEXT NOT NULL,
            url TEXT NOT NULL,
            episode INTEGER NOT NULL,
            season INTEGER NOT NULL
          )
          ''');
  }

  @override
  Future<Either<Failure, Unit>> addStory(StoryModel storyModel) async {
    try {
      final db = await database;
      await db.insert(
        table,
        storyModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao adicionar história: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StoryModel>>> getStories() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(table);

      List<StoryModel> stories =
          maps.map((map) => StoryModel.fromJson(map)).toList();

      return Right(stories);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao buscar histórias: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStory(StoryModel storyModel) async {
    try {
      final db = await database;
      int count = await db.update(
        table,
        storyModel.toJson(),
        where: 'id = ?',
        whereArgs: [storyModel.id],
      );

      if (count == 0) {
        return Left(DatabaseFailure(message: 'História não encontrada'));
      }

      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao atualizar história: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteStory(String id) async {
    try {
      final db = await database;
      int count = await db.delete(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        return Left(DatabaseFailure(message: 'História não encontrada'));
      }

      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Falha ao deletar história: $e'));
    }
  }
}
