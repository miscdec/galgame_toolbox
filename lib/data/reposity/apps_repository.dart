
import '../../domain/apps_database.dart';
import '../datasource/apps_local_db_data_source.dart';

class  AppsRepository {

  final AppsLocalDBDataSourceImpl _localDBDataSource;

  AppsRepository(this._localDBDataSource);

  Future<List<App>> getApps() async {
    return _localDBDataSource.getApps();
  }

  Stream<List<App>> watchApps() {
    return _localDBDataSource.watchApps();
  }

  Future<List<App>> getAppsByType(int type) async {
    return _localDBDataSource.getAppsByType(type);
  }

  Future<List<App>> getAppsByName(String name) async {
    return _localDBDataSource.getAppsByName(name);
  }

  Future<List<App>> getAppsByTag(String tag) async {
    return _localDBDataSource.getAppsByTag(tag);
  }

  Stream<List<App>> watchAppsByCatalog(String catalog) {
    return _localDBDataSource.watchAppsByGroup(catalog);
  }

  Future<List<App>> queryAppsByCategory(String catalog) async {
    return _localDBDataSource.getAppsByGroup(catalog);
  }

  Future<List<String>> getAppGroups() async {
    return _localDBDataSource.getAppGroups();
  }

  Stream<List<String>> watchAppGroups() {
    return _localDBDataSource.watchAppGroups();
  }

  Future<int> addAppShortcut(AppsCompanion appCompanion) async {
    return _localDBDataSource.addApp(appCompanion);
  }

  Future<int> deleteAppShortcut(App app) async {
    return _localDBDataSource.deleteApp(app);
  }
}