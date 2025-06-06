
import '../../domain/apps_database.dart' show App, AppsCompanion;
import '../reposity/apps_repository.dart';

class AppShortcutsUseCase {
  final AppsRepository appsRepository;
  AppShortcutsUseCase(this.appsRepository);

  Future<List<App>> getAppShortcuts() async {
    final apps = await appsRepository.getApps();
    return apps;
  }

  Future<List<App>> getAppShortcutsByName(String name) async {
    final apps = await appsRepository.getAppsByName(name);
    return apps;
  }

  Future<List<App>> getAppShortcutsByCategory(String category) async {
    final apps = await appsRepository.queryAppsByCategory(category);
    return apps;
  }

  Future<int> addShortcut(AppsCompanion appCompanion) async {
    // The repository method should also be named addShortcut or addAppShortcut for consistency
    return appsRepository.addAppShortcut(appCompanion);
  }

  Future<int> deleteShortcut(App app) async {
    return appsRepository.deleteAppShortcut(app);
  }
}
