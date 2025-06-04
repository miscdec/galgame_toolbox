
import 'package:galgame_toolbox/domain/apps_database.dart';
import 'package:galgame_toolbox/screens/launcher.dart';
import 'package:get_it/get_it.dart';

import 'data/datasource/apps_local_db_data_source.dart';
import 'data/reposity/apps_repository.dart';
import 'data/use_case/app_shortcuts_use_case.dart';

final GetIt di = GetIt.instance;

class ServiceLocator {
  
  static void init() {
    di.registerFactory(() => GridLayoutSizeBloc());
    di.registerLazySingleton(() => AppsDatabase());
    di.registerLazySingleton(() => AppsLocalDBDataSourceImpl(appsDatabase: di.get()));
    di.registerLazySingleton(() => AppsRepository(di.get()));
    di.registerLazySingleton(() => AppShortcutsUseCase(di.get()));
  }

}