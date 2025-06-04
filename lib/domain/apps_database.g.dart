// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps_database.dart';

// ignore_for_file: type=lint
class $AppsTable extends Apps with TableInfo<$AppsTable, App> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<Uint8List> icon = GeneratedColumn<Uint8List>(
      'icon', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commandMeta =
      const VerificationMeta('command');
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
      'command', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _groupMeta = const VerificationMeta('group');
  @override
  late final GeneratedColumn<String> group = GeneratedColumn<String>(
      'group', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        icon,
        path,
        description,
        command,
        url,
        type,
        group,
        tags,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apps';
  @override
  VerificationContext validateIntegrity(Insertable<App> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('command')) {
      context.handle(_commandMeta,
          command.isAcceptableOrUnknown(data['command']!, _commandMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('group')) {
      context.handle(
          _groupMeta, group.isAcceptableOrUnknown(data['group']!, _groupMeta));
    } else if (isInserting) {
      context.missing(_groupMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  App map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return App(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}icon'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      command: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      group: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AppsTable createAlias(String alias) {
    return $AppsTable(attachedDatabase, alias);
  }
}

class App extends DataClass implements Insertable<App> {
  final int id;
  final String name;
  final Uint8List icon;
  final String path;
  final String? description;
  final String? command;
  final String? url;
  final int type;
  final String group;
  final String tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const App(
      {required this.id,
      required this.name,
      required this.icon,
      required this.path,
      this.description,
      this.command,
      this.url,
      required this.type,
      required this.group,
      required this.tags,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<Uint8List>(icon);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || command != null) {
      map['command'] = Variable<String>(command);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['type'] = Variable<int>(type);
    map['group'] = Variable<String>(group);
    map['tags'] = Variable<String>(tags);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AppsCompanion toCompanion(bool nullToAbsent) {
    return AppsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      path: Value(path),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      command: command == null && nullToAbsent
          ? const Value.absent()
          : Value(command),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      type: Value(type),
      group: Value(group),
      tags: Value(tags),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory App.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return App(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<Uint8List>(json['icon']),
      path: serializer.fromJson<String>(json['path']),
      description: serializer.fromJson<String?>(json['description']),
      command: serializer.fromJson<String?>(json['command']),
      url: serializer.fromJson<String?>(json['url']),
      type: serializer.fromJson<int>(json['type']),
      group: serializer.fromJson<String>(json['group']),
      tags: serializer.fromJson<String>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<Uint8List>(icon),
      'path': serializer.toJson<String>(path),
      'description': serializer.toJson<String?>(description),
      'command': serializer.toJson<String?>(command),
      'url': serializer.toJson<String?>(url),
      'type': serializer.toJson<int>(type),
      'group': serializer.toJson<String>(group),
      'tags': serializer.toJson<String>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  App copyWith(
          {int? id,
          String? name,
          Uint8List? icon,
          String? path,
          Value<String?> description = const Value.absent(),
          Value<String?> command = const Value.absent(),
          Value<String?> url = const Value.absent(),
          int? type,
          String? group,
          String? tags,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      App(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        path: path ?? this.path,
        description: description.present ? description.value : this.description,
        command: command.present ? command.value : this.command,
        url: url.present ? url.value : this.url,
        type: type ?? this.type,
        group: group ?? this.group,
        tags: tags ?? this.tags,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  App copyWithCompanion(AppsCompanion data) {
    return App(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      path: data.path.present ? data.path.value : this.path,
      description:
          data.description.present ? data.description.value : this.description,
      command: data.command.present ? data.command.value : this.command,
      url: data.url.present ? data.url.value : this.url,
      type: data.type.present ? data.type.value : this.type,
      group: data.group.present ? data.group.value : this.group,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('App(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('path: $path, ')
          ..write('description: $description, ')
          ..write('command: $command, ')
          ..write('url: $url, ')
          ..write('type: $type, ')
          ..write('group: $group, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, $driftBlobEquality.hash(icon), path,
      description, command, url, type, group, tags, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is App &&
          other.id == this.id &&
          other.name == this.name &&
          $driftBlobEquality.equals(other.icon, this.icon) &&
          other.path == this.path &&
          other.description == this.description &&
          other.command == this.command &&
          other.url == this.url &&
          other.type == this.type &&
          other.group == this.group &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppsCompanion extends UpdateCompanion<App> {
  final Value<int> id;
  final Value<String> name;
  final Value<Uint8List> icon;
  final Value<String> path;
  final Value<String?> description;
  final Value<String?> command;
  final Value<String?> url;
  final Value<int> type;
  final Value<String> group;
  final Value<String> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const AppsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.path = const Value.absent(),
    this.description = const Value.absent(),
    this.command = const Value.absent(),
    this.url = const Value.absent(),
    this.type = const Value.absent(),
    this.group = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required Uint8List icon,
    required String path,
    this.description = const Value.absent(),
    this.command = const Value.absent(),
    this.url = const Value.absent(),
    required int type,
    required String group,
    required String tags,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        icon = Value(icon),
        path = Value(path),
        type = Value(type),
        group = Value(group),
        tags = Value(tags),
        createdAt = Value(createdAt);
  static Insertable<App> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<Uint8List>? icon,
    Expression<String>? path,
    Expression<String>? description,
    Expression<String>? command,
    Expression<String>? url,
    Expression<int>? type,
    Expression<String>? group,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (path != null) 'path': path,
      if (description != null) 'description': description,
      if (command != null) 'command': command,
      if (url != null) 'url': url,
      if (type != null) 'type': type,
      if (group != null) 'group': group,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<Uint8List>? icon,
      Value<String>? path,
      Value<String?>? description,
      Value<String?>? command,
      Value<String?>? url,
      Value<int>? type,
      Value<String>? group,
      Value<String>? tags,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return AppsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      path: path ?? this.path,
      description: description ?? this.description,
      command: command ?? this.command,
      url: url ?? this.url,
      type: type ?? this.type,
      group: group ?? this.group,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<Uint8List>(icon.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (group.present) {
      map['group'] = Variable<String>(group.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('path: $path, ')
          ..write('description: $description, ')
          ..write('command: $command, ')
          ..write('url: $url, ')
          ..write('type: $type, ')
          ..write('group: $group, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppsDatabase extends GeneratedDatabase {
  _$AppsDatabase(QueryExecutor e) : super(e);
  $AppsDatabaseManager get managers => $AppsDatabaseManager(this);
  late final $AppsTable apps = $AppsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [apps];
}

typedef $$AppsTableCreateCompanionBuilder = AppsCompanion Function({
  Value<int> id,
  required String name,
  required Uint8List icon,
  required String path,
  Value<String?> description,
  Value<String?> command,
  Value<String?> url,
  required int type,
  required String group,
  required String tags,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$AppsTableUpdateCompanionBuilder = AppsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<Uint8List> icon,
  Value<String> path,
  Value<String?> description,
  Value<String?> command,
  Value<String?> url,
  Value<int> type,
  Value<String> group,
  Value<String> tags,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$AppsTableTableManager extends RootTableManager<
    _$AppsDatabase,
    $AppsTable,
    App,
    $$AppsTableFilterComposer,
    $$AppsTableOrderingComposer,
    $$AppsTableCreateCompanionBuilder,
    $$AppsTableUpdateCompanionBuilder> {
  $$AppsTableTableManager(_$AppsDatabase db, $AppsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AppsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AppsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<Uint8List> icon = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> command = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<String> group = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AppsCompanion(
            id: id,
            name: name,
            icon: icon,
            path: path,
            description: description,
            command: command,
            url: url,
            type: type,
            group: group,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required Uint8List icon,
            required String path,
            Value<String?> description = const Value.absent(),
            Value<String?> command = const Value.absent(),
            Value<String?> url = const Value.absent(),
            required int type,
            required String group,
            required String tags,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AppsCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            path: path,
            description: description,
            command: command,
            url: url,
            type: type,
            group: group,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$AppsTableFilterComposer
    extends FilterComposer<_$AppsDatabase, $AppsTable> {
  $$AppsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<Uint8List> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get path => $state.composableBuilder(
      column: $state.table.path,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get command => $state.composableBuilder(
      column: $state.table.command,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get group => $state.composableBuilder(
      column: $state.table.group,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AppsTableOrderingComposer
    extends OrderingComposer<_$AppsDatabase, $AppsTable> {
  $$AppsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<Uint8List> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get path => $state.composableBuilder(
      column: $state.table.path,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get command => $state.composableBuilder(
      column: $state.table.command,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get group => $state.composableBuilder(
      column: $state.table.group,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppsDatabaseManager {
  final _$AppsDatabase _db;
  $AppsDatabaseManager(this._db);
  $$AppsTableTableManager get apps => $$AppsTableTableManager(_db, _db.apps);
}
