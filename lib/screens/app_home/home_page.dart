import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galgame_toolbox/route/route_constants.dart';
import 'package:galgame_toolbox/route/router.dart';
import 'package:galgame_toolbox/screens/shortcut.dart' show kAllShortcutsCategoryIdentifier;
import 'package:galgame_toolbox/theme.dart';
import 'package:galgame_toolbox/widgets/window_button.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';

import '../../data/use_case/shortcut_groups_use_case.dart';
import '../../models/layout_model.dart';
import '../../service_locator.dart';
import '../launcher.dart';

class FetchAppCategory extends LayoutEvent {
  const FetchAppCategory() : super();

  @override
  List<Object> get props => [];
}

class SelectPaneIndexChanged extends LayoutEvent {
  const SelectPaneIndexChanged(this.index) : super();
  final int index;

  @override
  List<Object> get props => [index];
}

class HomePageState extends LayoutState {
  const HomePageState({
    this.entries,
    this.index,
    this.filterText,
    this.gridLayout,
    this.gridLayoutSize,
    this.showGridLayout,
    this.showGridLayoutSize,
    this.showFilter,
    this.showPane,
    this.showPaneFooter,
    this.showPaneHeader,
    this.showPaneTitle,
    this.showPaneToggle,
  });

  final List<String>? entries;
  final int? index;
  final String? filterText;
  final GridLayout? gridLayout;
  final GridLayoutSize? gridLayoutSize;
  final bool? showGridLayout;
  final bool? showGridLayoutSize;
  final bool? showFilter;
  final bool? showPane;
  final bool? showPaneFooter;
  final bool? showPaneHeader;
  final bool? showPaneTitle;
  final bool? showPaneToggle;

  factory HomePageState.initial() {
    return HomePageState(
      entries: const [],
      index: 0,
      filterText: '',
      gridLayout: GridLayout.grid,
      gridLayoutSize: GridLayoutSize.small,
      showGridLayout: true,
      showGridLayoutSize: true,
      showFilter: true,
      showPane: true,
      showPaneFooter: true,
      showPaneHeader: true,
      showPaneTitle: true,
    );
  }

  HomePageState copyWith({
    List<String>? entries,
    int? index,
    String? filterText,
    GridLayout? gridLayout,
    GridLayoutSize? gridLayoutSize,
    bool? showGridLayout,
    bool? showGridLayoutSize,
    bool? showFilter,
    bool? showPane,
    bool? showPaneFooter,
    bool? showPaneHeader,
    bool? showPaneTitle,
    bool? showPaneToggle,
  }) {
    return HomePageState(
      entries: entries ?? this.entries,
      index: index ?? this.index,
      filterText: filterText ?? this.filterText,
      gridLayout: gridLayout ?? this.gridLayout,
      gridLayoutSize: gridLayoutSize ?? this.gridLayoutSize,
      showGridLayout: showGridLayout ?? this.showGridLayout,
      showGridLayoutSize: showGridLayoutSize ?? this.showGridLayoutSize,
      showFilter: showFilter ?? this.showFilter,
      showPane: showPane ?? this.showPane,
      showPaneFooter: showPaneFooter ?? this.showPaneFooter,
      showPaneHeader: showPaneHeader ?? this.showPaneHeader,
      showPaneTitle: showPaneTitle ?? this.showPaneTitle,
      showPaneToggle: showPaneToggle ?? this.showPaneToggle,
    );
  }
}

class HomePageBloc extends Bloc<LayoutEvent, HomePageState> {
  final shortcutGroupsUseCase = di.get<ShortcutGroupsUseCase>();

  final future = Future.delayed(const Duration(milliseconds: 500));

  HomePageBloc() : super(HomePageState.initial()) {
    on<FetchAppCategory>((event, emit) async {
      shortcutGroupsUseCase.getAppGroups().then((value) async {
        await future.whenComplete(() => emit(state.copyWith(
              entries: value,
              index: 0,
            )));
      });
    });
    on<SelectPaneIndexChanged>((event, emit) async {
      await future.whenComplete(() => emit(state.copyWith(
            index: event.index,
          )));
    });
  }
}

class AppHomePage extends StatefulWidget {
  const AppHomePage({
    super.key,
    // required this.title,
    required this.child,
    required this.shellContext,
  });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;
  final Widget child;
  final BuildContext? shellContext;

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> with WindowListener {
  bool value = false;

  String appTitle = 'Galgame Toolbox';

  // int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  late final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      key: const ValueKey('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (GoRouterState.of(context).uri.toString() != '/settings') {
          context.go('/settings');
        }
      },
    ),
    PaneItem(
      key: const ValueKey('/about'),
      icon: const Icon(FluentIcons.info),
      title: const Text('About'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (GoRouterState.of(context).uri.toString() != '/about') {
          context.go('/about');
        }
      },
    ),
    // _LinkPaneItemAction(
    //   icon: const Icon(FluentIcons.open_source),
    //   title: const Text('Source code'),
    //   link: 'https://github.com/bdlukaa/fluent_ui',
    //   body: const SizedBox.shrink(),
    // ),
  ];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);

    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        return NavigationView(
          key: viewKey,
          appBar: NavigationAppBar(
            automaticallyImplyLeading: false,
            leading: () {
              final enabled = widget.shellContext != null && router.canPop();

              final onPressed = enabled
                  ? () {
                      if (router.canPop()) {
                        context.pop();
                        setState(() {});
                      }
                    }
                  : null;
              return NavigationPaneTheme(
                data: NavigationPaneTheme.of(context),
                child: Builder(
                  builder: (context) => PaneItem(
                    icon:
                        const Center(child: Icon(FluentIcons.back, size: 12.0)),
                    title: Text(localizations.backButtonTooltip),
                    body: const SizedBox.shrink(),
                    enabled: enabled,
                  ).build(
                    context,
                    false,
                    onPressed,
                    displayMode: PaneDisplayMode.compact,
                  ),
                ),
              );
            }(),
            title: () {
              if (kIsWeb) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(appTitle),
                );
              }
              return DragToMoveArea(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(appTitle),
                ),
              );
            }(),
            actions:
                const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              if (!kIsWeb) WindowButtons(),
            ]),
          ),
          paneBodyBuilder: (item, child) {
            final name =
                item?.key is ValueKey ? (item!.key as ValueKey).value : null;
            return FocusTraversalGroup(
              key: ValueKey('body$name'),
              child: widget.child,
            );
          },
          pane: NavigationPane(
            selected: state.index,
            header: HomeHeaderWidget(appTheme: appTheme, theme: theme),
            displayMode: appTheme.displayMode,
            indicator: () {
              switch (appTheme.indicator) {
                case NavigationIndicators.end:
                  return const EndNavigationIndicator();
                case NavigationIndicators.sticky:
                  return const StickyNavigationIndicator();
              }
            }(),
            onItemPressed: (index) {
              BlocProvider.of<HomePageBloc>(context)
                  .add(SelectPaneIndexChanged(index));
            },
            items: buildOriginalItems(
                items: [
                  ...[
                    PaneItem(
                      key: const ValueKey('/'),
                      icon: const Icon(FluentIcons.home),
                      title: const Text('Home'),
                      body: const SizedBox.shrink(),
                    ),
                    PaneItem(
                      key: const ValueKey('/dashboard'),
                      icon: const Icon(FluentIcons.functional_manager_dashboard),
                      title: const Text('Dashboard'),
                      body: const SizedBox.shrink(),
                    ),
                  ],
                  PaneItemSeparator(),
                  PaneItemHeader(header: const Text('Tools')),
                  // The "All Shortcuts" item
                  PaneItem(
                    icon: const Icon(FluentIcons.bulleted_list), // Using a different icon for "All"
                    title: const Text('All Shortcuts'),
                    body: const SizedBox.shrink(),
                    onTap: () {
                      context.go('${RouteConstants.shortcut.routePath}/$kAllShortcutsCategoryIdentifier');
                    },
                  ),
                  // Then the dynamic items from state.entries
                  ...state.entries!.map((e) {
                    return PaneItem(
                      icon: const Icon(FluentIcons.toolbox), // Or specific icons per category if available
                      title: Text(e),
                      body: const SizedBox.shrink(), // Required
                      onTap: () {
                        context.go('${RouteConstants.shortcut.routePath}/$e');
                      },
                    );
                  }).toList()
                ]),
            footerItems: footerItems,
          ),
          onOpenSearch: searchFocusNode.requestFocus,
        );
      },
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  List<NavigationPaneItem> buildOriginalItems(
      {required List<NavigationPaneItem> items}) {
    return items.map<NavigationPaneItem>((paneItem) {
      PaneItem buildPaneItem(PaneItem item) {
        return PaneItem(
          key: item.key,
          icon: item.icon,
          title: item.title,
          body: item.body,
          onTap: () {
            final path = (item.key as ValueKey).value;
            if (GoRouterState.of(context).uri.toString() != path) {
              context.go(path);
            }
            item.onTap?.call();
          },
        );
      }

      if (paneItem is PaneItemExpander) {
        return PaneItemExpander(
          key: paneItem.key,
          icon: paneItem.icon,
          title: paneItem.title,
          body: paneItem.body,
          items: paneItem.items.map((item) {
            if (item is PaneItem) return buildPaneItem(item);
            return item;
          }).toList(),
        );
      }
      if (paneItem is PaneItem) return buildPaneItem(paneItem);
      return paneItem;
    }).toList();
  }

  List<NavigationPaneItem> fixedOriginalItems() {
    return [
      PaneItem(
        key: const ValueKey('/'),
        icon: const Icon(FluentIcons.home),
        title: const Text('Home'),
        body: const SizedBox.shrink(),
      ),
      PaneItem(
        key: const ValueKey('/dashboard'),
        icon: const Icon(FluentIcons.functional_manager_dashboard),
        title: const Text('Dashboard'),
        body: const SizedBox.shrink(),
      ),
      PaneItemHeader(header: const Text('Tools')),
    ];
  }
}

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    super.key,
    required this.appTheme,
    required this.theme,
  });

  final AppTheme appTheme;
  final FluentThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kOneLineTileHeight,
      child: ShaderMask(
        shaderCallback: (rect) {
          final color = appTheme.color.defaultBrushFor(
            theme.brightness,
          );
          return LinearGradient(
            colors: [
              color,
              color,
            ],
          ).createShader(rect);
        },
        child: const FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 80.0,
          textColor: Colors.white,
          duration: Duration.zero,
        ),
      ),
    );
  }
}

class _LinkPaneItemAction extends PaneItem {
  _LinkPaneItemAction({
    required super.icon,
    required this.link,
    required super.body,
    super.title,
  });

  final String link;

  @override
  Widget build(
    BuildContext context,
    bool selected,
    VoidCallback? onPressed, {
    PaneDisplayMode? displayMode,
    bool showTextOnTop = true,
    bool? autofocus,
    int? itemIndex,
  }) {
    return Link(
      uri: Uri.parse(link),
      builder: (context, followLink) => Semantics(
        link: true,
        child: super.build(
          context,
          selected,
          followLink,
          displayMode: displayMode,
          showTextOnTop: showTextOnTop,
          itemIndex: itemIndex,
          autofocus: autofocus,
        ),
      ),
    );
  }
}
