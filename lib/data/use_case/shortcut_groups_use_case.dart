
import '../datasource/apps_local_db_data_source.dart';

class ShortcutGroupsUseCase { 
  final AppsLocalDBDataSourceImpl _appsLocalDBDataSource;
  ShortcutGroupsUseCase(this._appsLocalDBDataSource);
  
  Future<List<String>> getAppGroups() async {
    return await _appsLocalDBDataSource.getAppGroups();
  }

  Stream<List<String>> watchAppGroups() {
    return _appsLocalDBDataSource.watchAppGroups();
  }
}