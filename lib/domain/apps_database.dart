import 'dart:io';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galgame_toolbox/utils/application.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/open.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../utils/drift.dart';

part 'apps_database.g.dart';

// 由Drift生成的数据库类
abstract class AppDbConnection extends DatabaseConnection {
  AppDbConnection(super.executor);
}

// 定义Apps表
class Apps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  BlobColumn get icon => blob()();
  TextColumn get path => text()();
  TextColumn get description => text().nullable()();
  TextColumn get command => text().nullable()();
  TextColumn get url => text().nullable()();
  IntColumn get type => integer()();
  TextColumn get group => text()();
  TextColumn get tags => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [Apps])
class AppsDatabase extends _$AppsDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppsDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection(
    file: checkAndRequestDBFile('apps'),
    key: "1234567abcdef",
  ));


  // 私有构造函数
  AppsDatabase._(DatabaseConnection conn) : super(conn);
  
  // 重写数据库打开时的方法（可选）
  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection({required File file, required String key}) {
    final token = RootIsolateToken.instance!;

    return NativeDatabase.createInBackground(
      file,
      isolateSetup: () async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(token);
        await setupSqlCipher();
      },
      setup: (rawDb) {
        assert(_debugCheckHasCipher(rawDb));
        rawDb.execute("PRAGMA key = '$key';");

        // Recommended option, not enabled by default on SQLCipher
        rawDb.config.doubleQuotedStringLiterals = false;
      },
    );
  }

  static bool _debugCheckHasCipher(Database database) {
    return database.select('PRAGMA cipher_version;').isNotEmpty;
  }

  // 获取所有不重复的分组名称
  Future<List<String>> getAllGroups() async {
    // 使用 distinct 去重，selectOnly 优化只查询需要的列
    final query = selectOnly(apps)
      ..addColumns([apps.group])
      ..distinct;

    final result = await query.map((row) => row.read(apps.group)).get();
    return result.whereType<String>().toList();
  }

  Stream<List<String>> watchAllGroups() {
    return select(apps)
      .map((row) => row.group)
      .watch();
  }

}

