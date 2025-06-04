
import 'package:fluent_ui/fluent_ui.dart';

enum RouteConstants {
  home(icon: FluentIcons.home),
  shortcut(icon: FluentIcons.link),
  app(icon: FluentIcons.app_icon_default),
  dashboard(icon: FluentIcons.functional_manager_dashboard),
  folder(icon: FluentIcons.folder),
  file(icon: FluentIcons.document),
  command(icon: FluentIcons.command_prompt),
  url(icon: FluentIcons.globe),
  custom(icon: FluentIcons.text_field),
  settings(icon: FluentIcons.settings),
  about(icon: FluentIcons.info),
  help(icon: FluentIcons.help),
  donate(icon: FluentIcons.payment_card),
  feedback(icon: FluentIcons.feedback),
  // privacy(icon: FluentIcons.privacy_policy_settings),
  // license(icon: FluentIcons.privacy_policy_settings)
  ;

  final IconData icon;

  const RouteConstants({
    required this.icon,
  });

}

extension RouteConstantExtension on RouteConstants {

  String get routeName {
    return name;
  }

  String get routePath {
    return "/$name";
  }

 }


