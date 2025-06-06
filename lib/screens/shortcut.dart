import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galgame_toolbox/domain/apps_database.dart' show App, AppsCompanion;
import 'package:galgame_toolbox/service_locator.dart';

import '../data/use_case/app_shortcuts_use_case.dart';
import '../widgets/add_shortcut_dialog.dart';
import '../widgets/delete_confirmation_dialog.dart';
// import '../models/layout_model.dart'; // Assuming this will be replaced by definitions below

// Base LayoutEvent
abstract class LayoutEvent extends Equatable {
  const LayoutEvent();

  @override
  List<Object?> get props => [];
}

// Base LayoutState
abstract class LayoutState extends Equatable {
  const LayoutState();

  @override
  List<Object?> get props => [];
}

class LayoutInitial extends LayoutState {
  const LayoutInitial();
}

// LayoutLoaded State
class LayoutLoaded<T> extends LayoutState {
  final T entries;
  final App? selectedShortcut;
  final String currentCategory;
  final DateTime timestamp;

  const LayoutLoaded({
    required this.entries,
    this.selectedShortcut,
    required this.currentCategory,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [entries, selectedShortcut, currentCategory, timestamp];

  LayoutLoaded<T> copyWith({
    T? entries,
    App? selectedShortcut,
    bool explicitlySetSelectedShortcut = false,
    String? currentCategory,
    DateTime? timestamp,
  }) {
    return LayoutLoaded<T>(
      entries: entries ?? this.entries,
      selectedShortcut: explicitlySetSelectedShortcut ? selectedShortcut : this.selectedShortcut,
      currentCategory: currentCategory ?? this.currentCategory,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class InitialLayoutEvent extends LayoutEvent {
  const InitialLayoutEvent({required this.category});

  final String category;

  @override
  List<Object> get props => [category];
}

class FilterEvent extends LayoutEvent {
  const FilterEvent({required this.filterText});

  final String filterText;

  @override
  List<Object> get props => [filterText];
}

// New LayoutEvents
class AddShortcutEvent extends LayoutEvent {
  final AppsCompanion newShortcutData;

  const AddShortcutEvent(this.newShortcutData);

  @override
  List<Object> get props => [newShortcutData];
}

class DeleteShortcutEvent extends LayoutEvent {
  final App shortcutToDelete;

  const DeleteShortcutEvent(this.shortcutToDelete);

  @override
  List<Object> get props => [shortcutToDelete];
}

class SelectShortcutEvent extends LayoutEvent {
  final App? shortcut; // Nullable for deselection

  const SelectShortcutEvent(this.shortcut);

  @override
  List<Object?> get props => [shortcut];
}

class ReloadShortcutsEvent extends LayoutEvent {
  const ReloadShortcutsEvent();
}

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  final AppShortcutsUseCase appShortcutUseCase = di.get<AppShortcutsUseCase>();

  LayoutBloc() : super(const LayoutInitial()) {
    on<InitialLayoutEvent>((event, emit) async {
      final entries = await appShortcutUseCase.getAppShortcutsByCategory(event.category);
      emit(LayoutLoaded<List<App>>(
        entries: entries,
        selectedShortcut: null,
        currentCategory: event.category,
        timestamp: DateTime.now(),
      ));
    });
    on<FilterEvent>((event, emit) async {
      final entries = await appShortcutUseCase.getAppShortcutsByName(event.filterText);
      emit(LayoutLoaded<List<App>>(
        entries: entries,
        selectedShortcut: null,
        currentCategory: "filtered:${event.filterText}",
        timestamp: DateTime.now(),
      ));
    });
    on<AddShortcutEvent>((event, emit) async {
      final String newItemGroupGroup = event.newShortcutData.group.value;

      await appShortcutUseCase.addShortcut(event.newShortcutData);

      if (state is LayoutLoaded<List<App>>) {
        add(const ReloadShortcutsEvent());
      } else {
        add(InitialLayoutEvent(category: newItemGroupGroup));
      }
    });
    on<DeleteShortcutEvent>((event, emit) async {
      if (state is LayoutLoaded<List<App>>) {
        final loadedState = state as LayoutLoaded<List<App>>;
        await appShortcutUseCase.deleteShortcut(event.shortcutToDelete);
        if (loadedState.selectedShortcut == event.shortcutToDelete) {
          emit(loadedState.copyWith(
              selectedShortcut: null,
              explicitlySetSelectedShortcut: true,
          ));
          add(const ReloadShortcutsEvent());
        } else {
          add(const ReloadShortcutsEvent());
        }
      }
    });
    on<SelectShortcutEvent>((event, emit) {
      if (state is LayoutLoaded<List<App>>) {
        final loadedState = state as LayoutLoaded<List<App>>;
        emit(loadedState.copyWith(
          selectedShortcut: event.shortcut,
          explicitlySetSelectedShortcut: true,
          timestamp: loadedState.timestamp,
        ));
      }
    });
    on<ReloadShortcutsEvent>((event, emit) async {
      if (state is LayoutLoaded<List<App>>) {
        final loadedState = state as LayoutLoaded<List<App>>;
        final categoryToReload = loadedState.currentCategory;

        List<App> entries;
        if (categoryToReload.startsWith("filtered:")) {
            entries = await appShortcutUseCase.getAppShortcutsByName(categoryToReload.replaceFirst("filtered:", ""));
        } else {
            entries = await appShortcutUseCase.getAppShortcutsByCategory(categoryToReload);
        }

        App? newSelectedShortcut;
        if (loadedState.selectedShortcut != null) {
          newSelectedShortcut = entries.firstWhere((app) => app.id == loadedState.selectedShortcut!.id, orElse: () => null);
        }

        emit(LayoutLoaded<List<App>>(
          entries: entries,
          selectedShortcut: newSelectedShortcut,
          currentCategory: categoryToReload,
          timestamp: DateTime.now(),
        ));
      }
    });
  }
}

class Shortcut extends StatelessWidget {
  const Shortcut({super.key, required this.group});

  final String group;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LayoutBloc>(
      create: (context) => LayoutBloc()..add(InitialLayoutEvent(category: group)),
      child: BlocBuilder<LayoutBloc, LayoutState>(
        builder: (context, state) {
          // Handle LayoutInitial state
          if (state is LayoutInitial) {
            return const ScaffoldPage( // Use ScaffoldPage for consistent structure
              header: PageHeader(title: Text("Loading...")), // Simple header for loading
              content: Center(child: ProgressRing()),
            );
          }

          // Handle LayoutLoaded state
          if (state is LayoutLoaded<List<App>>) {
            final loadedState = state; // state is already LayoutLoaded<List<App>>
            final App? selectedShortcut = loadedState.selectedShortcut;

            return ScaffoldPage(
              header: PageHeader(
                title: Text('Shortcuts: $group'), // Dynamic title
                commandBar: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      child: const Text('Add Shortcut'),
                      onPressed: () {
                        _showAddShortcutDialog(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    Button(
                      child: const Text('Delete Shortcut'),
                      onPressed: selectedShortcut == null ? null : () {
                        // Ensure selectedShortcut is not null before calling (already handled by enabled state)
                        if (selectedShortcut != null) {
                          showDeleteConfirmationDialog(
                            context: context, // The BuildContext from the Shortcut widget's build method
                            shortcutToDelete: selectedShortcut,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 240.0,
                      child: Tooltip(
                        message: 'Filter by name',
                        child: TextBox(
                          suffix: const Icon(FluentIcons.search),
                          placeholder: 'Type to filter apps by name',
                          onChanged: (value) {
                            BlocProvider.of<LayoutBloc>(context).add(FilterEvent(filterText: value));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomBar: const SizedBox(
                width: double.infinity,
                child: InfoBar(
                  title: Text('Tip:'),
                  content: Text('Click an item to select it. Use buttons above to Add or Delete shortcuts.'),
                ),
              ),
              content: GridView.builder(
                padding: EdgeInsetsDirectional.only(
                  start: PageHeader.horizontalPadding(context),
                  end: PageHeader.horizontalPadding(context),
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: loadedState.entries.length,
                itemBuilder: (context, index) {
                  final e = loadedState.entries.elementAt(index);
                  final bool isSelected = selectedShortcut == e;
                  return HoverButton(
                    onPressed: () {
                      BlocProvider.of<LayoutBloc>(context).add(SelectShortcutEvent(isSelected ? null : e));
                    },
                    cursor: SystemMouseCursors.click, // Changed cursor
                    builder: (context, states) {
                      return FocusBorder(
                        focused: states.isFocused,
                        renderOutside: false,
                        child: Tooltip(
                          useMousePosition: false,
                          message: e.description ?? 'no description',
                          child: RepaintBoundary(
                            child: AnimatedContainer(
                              duration: FluentTheme.of(context).fasterAnimationDuration,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? FluentTheme.of(context).accentColor?.withOpacity(0.3)
                                    : ButtonThemeData.uncheckedInputColor(
                                        FluentTheme.of(context),
                                        states,
                                        transparentWhenNone: true,
                                      ),
                                border: isSelected
                                    ? Border.all(color: FluentTheme.of(context).accentColor!, width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox.fromSize(
                                    size: const Size(40, 40),
                                    child: Image.memory(e.icon, height: 40, width: 40),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(top: 8.0),
                                    child: Text(
                                      e.name,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          // Fallback for any other unexpected state
          return ScaffoldPage(
            header: PageHeader(title: Text("Error")),
            content: Center(
              child: Text('Unexpected state: ${state.runtimeType}'),
            ),
          );
        },
      ),
    );
  }
}

void _showAddShortcutDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return const AddShortcutDialog();
    },
  );
}

Future<void> showCopiedSnackbar(BuildContext context, String copiedText) {
  return displayInfoBar(
    context,
    builder: (context, close) => InfoBar(
      title: RichText(
        text: TextSpan(
          text: 'You click',
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: copiedText,
              style: TextStyle(
                color: Colors.blue.defaultBrushFor(
                  FluentTheme.of(context).brightness,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

