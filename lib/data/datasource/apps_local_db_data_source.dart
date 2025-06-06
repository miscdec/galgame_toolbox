
import 'package:drift/drift.dart';

import '../../domain/apps_database.dart';

abstract class AppsLocalDBDataSource {

  Future<List<String>> getAppGroups();
  Stream<List<String>> watchAppGroups();

  Future<List<App>> getApps();
  Stream<List<App>> watchApps();

  Future<List<App>> queryApps(String word);
  Stream<List<App>> watchAppsByWord(String name);

  Future<List<App>> getAppsByType(int type);
  Future<List<App>> getAppsByGroup(String group);
  Future<List<App>> getAppsByName(String name);
  Future<List<App>> getAppsByTag(String tag);
  
  Stream<List<App>> watchAppsByGroup(String group);
  Stream<List<App>> watchAppsByName(String name);
  Stream<List<App>> watchAppsByType(int type);

  Future<void> addApps(List<AppsCompanion> apps);
  Future<int> addApp(AppsCompanion app);

  Future<void> updateApps(List<App> apps);
  Future<bool> updateApp(App app);

  Future<void> deleteApps(List<App> apps);
  Future<int> deleteApp(App app);
  Future<void> deleteAllApps();

}

class AppsLocalDBDataSourceImpl implements AppsLocalDBDataSource {
  AppsLocalDBDataSourceImpl({required AppsDatabase appsDatabase}) : _db = appsDatabase;

  final AppsDatabase _db;

  @override
  Future<int> addApp(AppsCompanion app) {
    return _db.into(_db.apps).insert(app);
  }

  @override
  Future<void> addApps(List<AppsCompanion> apps) async{
    for (var app in apps) {
      _db.into(_db.apps).insert(app);
    }
  }

  @override
  Future<void> deleteAllApps() async {
    _db.delete(_db.apps);
  }

  @override
  Future<int> deleteApp(App app) {
    return _db.delete(_db.apps).delete(app);
  }

  @override
  Future<void> deleteApps(List<App> apps) async {
    for (var app in apps) {
      _db.delete(_db.apps).delete(app);
    }

  }

  @override
  Future<List<App>> getApps() {
    return _db.select(_db.apps).get();
  }

  @override
  Stream<List<App>> watchApps() {
    return _db.select(_db.apps).watch();
  }

  @override
  Future<List<App>> getAppsByGroup(String group) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.group.equals(group))
    ).get();
  }

  @override
  Stream<List<App>> watchAppsByWord(String name){
    return (
        _db.select(_db.apps)
            ..where((app) => app.name.like('%$name%'))
    )
        .watch();
  }

  @override
  Future<List<App>> getAppsByName(String name) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.name.like('%$name%'))
    ).get();
  }

  @override
  Future<List<App>> getAppsByType(int type) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.type.equals(type))
    ).get();
  }

  @override
  Future<List<App>> queryApps(String name) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.name.like('%$name%'))
    ).get();
  }

  @override
  Future<bool> updateApp(App app) {
    return _db.update(_db.apps).replace(app);
  }

  @override
  Future<void> updateApps(List<App> apps) async {
    for (var app in apps) {
      _db.update(_db.apps).replace(app);
    }
  }

  @override
  Stream<List<App>> watchAppsByGroup(String group) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.group.equals(group))
    ).watch();
  }

  @override
  Stream<List<App>> watchAppsByName(String name) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.name.equals(name))
    ).watch();
  }

  @override
  Stream<List<App>> watchAppsByType(int type) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.type.equals(type))
    ).watch();
  }

  @override
  Future<List<App>> getAppsByTag(String tag) {
    return (
        _db.select(_db.apps)
            ..where((app) => app.tags.like('%$tag%'))
    ).get();
  }

  @override
  Future<List<String>> getAppGroups() async {
    return _db.getAllGroups();
  }

  @override
  Stream<List<String>> watchAppGroups() {
    return _db.watchAllGroups();
  }





}
