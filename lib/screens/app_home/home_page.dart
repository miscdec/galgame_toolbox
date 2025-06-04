


import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galgame_toolbox/route/router.dart';
import 'package:galgame_toolbox/theme.dart';
import 'package:galgame_toolbox/widgets/window.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';

import '../../data/use_case/shortcut_groups_use_case.dart';
import '../../models/layout_model.dart';
import '../../service_locator.dart';

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

class IndexSelectState extends LayoutState {
  const IndexSelectState({
    this.index = 0,
  });

  final int index;
}

class HomePageBloc extends Bloc<LayoutEvent, LayoutState> {

  final shortcutGroupsUseCase = di.get<ShortcutGroupsUseCase>();

  HomePageBloc() : super(const LayoutInitial()) {
    on<FetchAppCategory>((event, emit) {
      shortcutGroupsUseCase.getAppGroups().then((value) {
        emit(LayoutLoaded<List<String>>(entries: value));
      });
    });
    on<SelectPaneIndexChanged>((event, emit) {
      emit(IndexSelectState(index: event.index));
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

  List<NavigationPaneItem> buildItems(BuildContext context){
    return [
      ...buildOriginalItems(context),
      PaneItemSeparator(),
      ...footerItems,
    ];
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int indexOriginal = buildOriginalItems(context)
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) => item.key == Key(location));

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == Key(location));
      if (indexFooter == -1) {
        return 0;
      }
      return buildOriginalItems(context)
          .where((element) => element.key != null)
          .toList()
          .length + indexFooter;
    } else {
      return indexOriginal;
    }
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
                icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
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
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          // if(appTheme.displayMode != PaneDisplayMode.minimal) Align(
          //   alignment: AlignmentDirectional.centerEnd,
          //   child: Padding(
          //     padding: const EdgeInsetsDirectional.only(end: 8.0),
          //     child: ToggleSwitch(
          //       content: const Text('Dark Mode'),
          //       checked: FluentTheme.of(context).brightness.isDark,
          //       onChanged: (v) {
          //         if (v) {
          //           appTheme.mode = ThemeMode.dark;
          //         } else {
          //           appTheme.mode = ThemeMode.light;
          //         }
          //       },
          //     ),
          //   ),
          // ),
          if (!kIsWeb) const WindowButtons(),
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
        selected: _calculateSelectedIndex(context),
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
        items: buildOriginalItems(context),
        autoSuggestBox: Builder(builder: (context) {
          return AutoSuggestBox(
            key: searchKey,
            focusNode: searchFocusNode,
            controller: searchController,
            unfocusedColor: Colors.transparent,
            // also need to include sub items from [PaneItemExpander] items
            items: <PaneItem>[
              ...buildOriginalItems(context)
                  .whereType<PaneItemExpander>()
                  .expand<PaneItem>((item) {
                return [
                  item,
                  ...item.items.whereType<PaneItem>(),
                ];
              }),
              ...buildOriginalItems(context)
                  .where(
                    (item) => item is PaneItem && item is! PaneItemExpander,
              )
                  .cast<PaneItem>(),
            ].map((item) {
              assert(item.title is Text);
              final text = (item.title as Text).data!;
              return AutoSuggestBoxItem(
                label: text,
                value: text,
                onSelected: () {
                  item.onTap?.call();
                  searchController.clear();
                  searchFocusNode.unfocus();
                  final view = NavigationView.of(context);
                  if (view.compactOverlayOpen) {
                    view.compactOverlayOpen = false;
                  } else if (view.minimalPaneOpen) {
                    view.minimalPaneOpen = false;
                  }
                },
              );
            }).toList(),
            trailingIcon: IgnorePointer(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(FluentIcons.search),
              ),
            ),
            placeholder: 'Search',
          );
        }),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: searchFocusNode.requestFocus,
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



List<NavigationPaneItem> buildOriginalItems(BuildContext context){
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
    PaneItemHeader(header: const Text('Inputs')),
    // TODO: Scrollbar, RatingBar
  ].map<NavigationPaneItem>((paneItem) {
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

