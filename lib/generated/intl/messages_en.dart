// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_build_name": MessageLookupByLibrary.simpleMessage("1.0.0"),
        "app_build_number": MessageLookupByLibrary.simpleMessage("1"),
        "app_copyright": MessageLookupByLibrary.simpleMessage(
            "Copyright © 2021 Yuji Nakayama. All rights reserved."),
        "app_description":
            MessageLookupByLibrary.simpleMessage("A new Flutter project."),
        "app_license": MessageLookupByLibrary.simpleMessage("MIT License"),
        "app_license_url": MessageLookupByLibrary.simpleMessage(
            "https://opensource.org/licenses/MIT"),
        "app_name": MessageLookupByLibrary.simpleMessage("Galgame Toolbox"),
        "app_title":
            MessageLookupByLibrary.simpleMessage("Flutter Demo Home Page"),
        "app_version": MessageLookupByLibrary.simpleMessage("1.0.0"),
        "author": MessageLookupByLibrary.simpleMessage("Yuji Nakayama")
      };
}
