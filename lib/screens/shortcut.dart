import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galgame_toolbox/domain/apps_database.dart';
import 'package:galgame_toolbox/service_locator.dart';

import '../data/use_case/app_shortcuts_use_case.dart';
import '../models/layout_model.dart';



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

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  final AppShortcutsUseCase appShortcutUseCase = di.get<AppShortcutsUseCase>();

  LayoutBloc() : super(const LayoutInitial()) {
    on<InitialLayoutEvent>((event, emit) async {
      final entries =
          await appShortcutUseCase.getAppShortcutsByCategory(event.category);
      emit(LayoutLoaded<List<App>>(entries: entries));
    });
    on<FilterEvent>((event, emit) async {
      final entries =
          await appShortcutUseCase.getAppShortcutsByName(event.filterText);
      emit(LayoutLoaded<List<App>>(entries: entries));
    });
  }
}

class Shortcut extends StatelessWidget {
  const Shortcut({super.key, required this.group});

  final String group;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        if (state is LayoutInitial) {
          return const Center(
            child: Text('Loading ...'),
          );
        } else if (state is LayoutLoaded) {
          String filterText = '';
          return ScaffoldPage(
            header: PageHeader(
              title: const Text('Fluent Icons Gallery showcase'),
              commandBar: SizedBox(
                width: 240.0,
                child: Tooltip(
                  message: 'Filter by name',
                  child: TextBox(
                      suffix: const Icon(FluentIcons.search),
                      placeholder: 'Type to filter apps by name',
                      onChanged: (value) => () {
                            filterText = value;
                            BlocProvider.of<LayoutBloc>(context)
                                .add(FilterEvent(filterText: filterText));
                          }),
                ),
              ),
            ),
            bottomBar: const SizedBox(
              width: double.infinity,
              child: InfoBar(
                title: Text('Tip:'),
                content: Text(
                  'You can click on any icon to lunch the app!',
                ),
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
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final e = state.entries.elementAt(index);
                return HoverButton(
                  onPressed: () async {
                    if (context.mounted) showCopiedSnackbar(context, e.name);
                  },
                  cursor: SystemMouseCursors.copy,
                  builder: (context, states) {
                    return FocusBorder(
                      focused: states.isFocused,
                      renderOutside: false,
                      child: Tooltip(
                        useMousePosition: false,
                        message: e.description ?? 'no description',
                        child: RepaintBoundary(
                          child: AnimatedContainer(
                            duration:
                                FluentTheme.of(context).fasterAnimationDuration,
                            decoration: BoxDecoration(
                              color: ButtonThemeData.uncheckedInputColor(
                                FluentTheme.of(context),
                                states,
                                transparentWhenNone: true,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox.fromSize(
                                  size: const Size(40, 40),
                                  child: Image.memory(e.icon, height: 40,width: 40),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 8.0),
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
        return const SizedBox();
      },
    );
  }
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

