
import '../../domain/apps_database.dart';
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
}
