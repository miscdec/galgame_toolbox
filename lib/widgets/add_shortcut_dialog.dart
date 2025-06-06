import 'dart:io'; // For File
import 'dart:typed_data'; // For Uint8List
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // To access LayoutBloc via context.read
import 'package:file_picker/file_picker.dart'; // For file picking
import 'package:galgame_toolbox/domain/apps_database.dart' show AppsCompanion; // For AppsCompanion
import 'package:galgame_toolbox/models/app_shortcut.dart' show AppShortcutType; // For AppShortcutType enum/constants
import 'package:galgame_toolbox/screens/shortcut.dart' show AddShortcutEvent, LayoutBloc; // LayoutBloc for context.read<LayoutBloc>
import 'package:drift/drift.dart' show Value; // For Value.absent() and Value()

class AddShortcutDialog extends StatefulWidget {
  const AddShortcutDialog({super.key});

  @override
  State<AddShortcutDialog> createState() => _AddShortcutDialogState();
}

class _AddShortcutDialogState extends State<AddShortcutDialog> {
  // final _formKey = GlobalKey<FormState>(); // Removed
  Uint8List? _iconBytes;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pathController = TextEditingController(); // Main field for path/url/command
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  int _selectedType = AppShortcutType.app;

  @override
  void dispose() {
    _nameController.dispose();
    _pathController.dispose();
    _descriptionController.dispose();
    _groupController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      try {
        final bytes = await file.readAsBytes();
        setState(() {
          _iconBytes = bytes;
        });
      } catch (e) {
        debugPrint('Error reading icon file: $e');
        // Optionally show an error to the user (e.g., using an InfoBar)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Add New Shortcut'),
      content: SingleChildScrollView(
        child: Column( // Removed Form widget
          // key: _formKey, // Removed
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InfoLabel(label: 'Name*'),
            TextBox(
              controller: _nameController,
              placeholder: 'Enter shortcut name',
              // validator: (value) => (value == null || value.trim().isEmpty) ? 'Name is required' : null, // Removed
            ),
            const SizedBox(height: 10),
            InfoLabel(label: 'Target (Path / App ID / Command / URL)*'),
            TextBox(
              controller: _pathController,
              placeholder: 'Value depends on Type selection',
              // validator: (value) => (value == null || value.trim().isEmpty) ? 'Target field is required' : null, // Removed
              ),
              const SizedBox(height: 10),
              InfoLabel(
                label: 'Icon (PNG format)*',
                child: Button(
                  onPressed: _pickIcon,
                  child: Text(_iconBytes == null ? 'Pick Icon' : 'Change Icon'),
                ),
              ),
              if (_iconBytes != null) ...[
                const SizedBox(height: 5),
                Image.memory(_iconBytes!, height: 48, width: 48, fit: BoxFit.contain),
              ], // Removed specific error text for icon here
              const SizedBox(height: 10),
              InfoLabel(
                label: 'Type*',
                child: ComboBox<int>( // Corrected casing
                  value: _selectedType,
                  items: const [ // Use ComboBoxItem
                    ComboBoxItem(value: AppShortcutType.app, child: Text('Application (ID or Path)')),
                    ComboBoxItem(value: AppShortcutType.file, child: Text('File Path')),
                    ComboBoxItem(value: AppShortcutType.folder, child: Text('Folder Path')),
                    ComboBoxItem(value: AppShortcutType.url, child: Text('Website URL')),
                    ComboBoxItem(value: AppShortcutType.command, child: Text('Shell Command')),
                    ComboBoxItem(value: AppShortcutType.local_drive, child: Text('Local Drive')),
                    ComboBoxItem(value: AppShortcutType.network_drive, child: Text('Network Drive')),
                    ComboBoxItem(value: AppShortcutType.custom, child: Text('Custom')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() { _selectedType = value; });
                    }
                  },
                  isExpanded: true,
                ),
              ),
              const SizedBox(height: 10),
              InfoLabel(label: 'Group*'),
              TextBox(
                controller: _groupController,
                placeholder: 'Enter group name (e.g., Games, Work)',
                // validator: (value) => (value == null || value.trim().isEmpty) ? 'Group is required' : null, // Removed
              ),
              const SizedBox(height: 10),
              InfoLabel(label: 'Tags (comma-separated)*'),
              TextBox(
                controller: _tagsController,
                placeholder: 'e.g., utility, productivity, fun',
                // validator: (value) => (value == null || value.trim().isEmpty) ? 'Tags are required' : null, // Removed
              ),
              const SizedBox(height: 10),
              InfoLabel(label: 'Description (Optional)'), // InfoLabel for consistency
              TextBox(
                controller: _descriptionController,
                placeholder: 'Enter a brief description',
                maxLines: 2,
              ),
            ],
          ),
        ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          child: const Text('Save Shortcut'),
          onPressed: () {
            // Clear previous error messages if any (if using state for errors)
            // setState(() { _nameError = null; _pathError = null; ... });

            bool isValid = true;
            String? firstErrorMessage;

            if (_nameController.text.trim().isEmpty) {
              isValid = false;
              firstErrorMessage ??= 'Name is required.';
              // setState(() { _nameError = 'Name is required.'; });
            }
            if (_pathController.text.trim().isEmpty) {
              isValid = false;
              firstErrorMessage ??= 'Target (Path / App ID / Command / URL) is required.';
              // setState(() { _pathError = 'Target field is required.'; });
            }
            if (_iconBytes == null) {
              isValid = false;
              firstErrorMessage ??= 'Icon is required.';
              // setState(() { _iconError = 'Icon is required.'; });
            }
            if (_groupController.text.trim().isEmpty) {
              isValid = false;
              firstErrorMessage ??= 'Group is required.';
              // setState(() { _groupError = 'Group is required.'; });
            }
            if (_tagsController.text.trim().isEmpty) {
              isValid = false;
              firstErrorMessage ??= 'Tags are required.';
              // setState(() { _tagsError = 'Tags are required.'; });
            }

            if (isValid) {
              // ... (existing logic to create AppsCompanion and dispatch event) ...
              // This part remains the same as before:
              String formTargetValue = _pathController.text.trim();
              Value<String> dbPath;
              Value<String> dbCommand = const Value.absent();
              Value<String> dbUrl = const Value.absent();

              if (_selectedType == AppShortcutType.url) {
                dbUrl = Value(formTargetValue);
                dbPath = const Value('');
              } else if (_selectedType == AppShortcutType.command) {
                dbCommand = Value(formTargetValue);
                dbPath = const Value('');
              } else {
                dbPath = Value(formTargetValue);
              }

              final newShortcut = AppsCompanion(
                name: Value(_nameController.text.trim()),
                icon: Value(_iconBytes!), // Already checked _iconBytes != null
                path: dbPath,
                command: dbCommand,
                url: dbUrl,
                type: Value(_selectedType),
                group: Value(_groupController.text.trim()),
                tags: Value(_tagsController.text.trim()),
                description: _descriptionController.text.trim().isEmpty
                             ? const Value.absent()
                             : Value(_descriptionController.text.trim()),
                createdAt: Value(DateTime.now()),
              );

              context.read<LayoutBloc>().add(AddShortcutEvent(newShortcut));
              Navigator.pop(context,"User add ");

            } else {
              // Show the first validation error using an InfoBar
              displayInfoBar(
                context,
                builder: (infobarContext, close) {
                  return InfoBar(
                    title: const Text('Validation Error'),
                    content: Text(firstErrorMessage!),
                    severity: InfoBarSeverity.error,
                    isLong: true,
                    action: Button(
                      child: const Text('Dismiss'),
                      onPressed: close,
                    ),
                  );
                },
                duration: const Duration(seconds: 5), // Auto-dismiss after 5 seconds
              );
              debugPrint("Validation failed: $firstErrorMessage");
            }
          },
        ),
      ],
    );
  }
}
