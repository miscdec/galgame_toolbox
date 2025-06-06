import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // For context.read<LayoutBloc>
import 'package:galgame_toolbox/domain/apps_database.dart' show App; // For App type
import 'package:galgame_toolbox/screens/shortcut.dart' show DeleteShortcutEvent, LayoutBloc; // For DeleteShortcutEvent and LayoutBloc

// It's a good practice to make dialogs reusable, so we pass the shortcut to delete.
// A simple function can show this dialog.

Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required App shortcutToDelete,
}) async {
  await showDialog<bool>( // Return bool indicating if confirmed
    context: context,
    builder: (BuildContext dialogContext) {
      return ContentDialog(
        title: Text('Delete Shortcut: ${shortcutToDelete.name}?'),
        content: const Text('Are you sure you want to delete this shortcut? This action cannot be undone.'),
        actions: [
          Button(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(false); // Not confirmed
            },
          ),
          FilledButton(
            style: ButtonStyle(backgroundColor: ButtonState.all(Colors.red.darker)),
            child: const Text('Delete'),
            onPressed: () {
              // Dispatch the delete event using the original context (or context.read from dialogContext if Bloc is above)
              // It's often cleaner to pass the BLoC or use context.read from the calling context if dialog is simple.
              // Here, using context.read from the dialogContext should work if BlocProvider is high enough.
              dialogContext.read<LayoutBloc>().add(DeleteShortcutEvent(shortcutToDelete));
              Navigator.of(dialogContext).pop(true); // Confirmed
            },
          ),
        ],
      );
    },
  );
}
