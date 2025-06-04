

import 'package:fluent_ui/fluent_ui.dart';

class AppShortcut {
  final int type;
  final String name;
  final Image icon;
  final String? path;
  final String? command;
  final String? url;
  final String? description;
  final String group;
  final String tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppShortcut({
    required this.type,
    required this.name,
    required this.icon,
    this.path,
    this.command,
    this.url,
    this.description,
    this.group = '',
    this.tags = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();


  factory AppShortcut.fromJson(Map<String, dynamic> json) {
    return AppShortcut(
      type: json['type'],
      name: json['name'],
      icon: json['icon'],
      path: json['path'],
      command: json['command'],
      url: json['url'],
      description: json['description'],
      group: json['group'],
      tags: json['tags'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'icon': icon,
      'path': path,
      'command': command,
      'url': url,
      'description': description,
      'group': group,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

}

sealed class AppShortcutType {
  static const int network_drive = 0; //smb、nfs、cifs等云存储
  static const int local_drive = 1; //本地存储
  static const int app = 2; //app标识符，如：com.example.app
  static const int folder = 3; //文件夹
  static const int file = 4;
  static const int command = 5; //shell 命令
  static const int url = 6; //web url, 如：https://、http://、
  static const int custom = 7;
}