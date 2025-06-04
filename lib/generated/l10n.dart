// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Galgame Toolbox`
  String get app_name {
    return Intl.message(
      'Galgame Toolbox',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `A new Flutter project.`
  String get app_description {
    return Intl.message(
      'A new Flutter project.',
      name: 'app_description',
      desc: '',
      args: [],
    );
  }

  /// `Flutter Demo Home Page`
  String get app_title {
    return Intl.message(
      'Flutter Demo Home Page',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `Yuji Nakayama`
  String get author {
    return Intl.message(
      'Yuji Nakayama',
      name: 'author',
      desc: '',
      args: [],
    );
  }

  /// `1.0.0`
  String get app_version {
    return Intl.message(
      '1.0.0',
      name: 'app_version',
      desc: '',
      args: [],
    );
  }

  /// `1`
  String get app_build_number {
    return Intl.message(
      '1',
      name: 'app_build_number',
      desc: '',
      args: [],
    );
  }

  /// `1.0.0`
  String get app_build_name {
    return Intl.message(
      '1.0.0',
      name: 'app_build_name',
      desc: '',
      args: [],
    );
  }

  /// `Copyright © 2021 Yuji Nakayama. All rights reserved.`
  String get app_copyright {
    return Intl.message(
      'Copyright © 2021 Yuji Nakayama. All rights reserved.',
      name: 'app_copyright',
      desc: '',
      args: [],
    );
  }

  /// `MIT License`
  String get app_license {
    return Intl.message(
      'MIT License',
      name: 'app_license',
      desc: '',
      args: [],
    );
  }

  /// `https://opensource.org/licenses/MIT`
  String get app_license_url {
    return Intl.message(
      'https://opensource.org/licenses/MIT',
      name: 'app_license_url',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
