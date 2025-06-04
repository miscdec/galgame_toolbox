import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galgame_toolbox/widgets/app_card.dart';

import '../models/layout_model.dart';
import '../route/router.dart';

class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

enum FilterEvent {
  all,
  favorites,
  recent,
  installed,
  downloading,
  updating,
  uninstalled,
}

enum GridLayout {
  list,
  grid,
}

enum GridLayoutSize {
  small(120),
  medium(150),
  large(300);

  final double value;

  const GridLayoutSize(this.value);
}

class GridLayoutState extends LayoutState {
  const GridLayoutState(this.layout, this.size);

  final GridLayout layout;
  final GridLayoutSize size;

  GridLayoutState copyWith({
    GridLayout? layout,
    GridLayoutSize? size,
  }) {
    return GridLayoutState(
      layout ?? this.layout,
      size ?? this.size,
    );
  }
}

class SwitchLayout extends LayoutEvent {
  const SwitchLayout(this.layout);

  final GridLayout layout;

  @override
  List<Object> get props => [layout];
}

class SwitchGridSize extends LayoutEvent {
  const SwitchGridSize(this.size);

  final GridLayoutSize size;

  @override
  List<Object> get props => [size];
}

class GridLayoutSizeBloc extends Bloc<LayoutEvent, GridLayoutState> {
  GridLayoutSizeBloc()
      : super(const GridLayoutState(GridLayout.grid, GridLayoutSize.medium)) {
    on<SwitchLayout>((event, emit) {
      emit(state.copyWith(layout: event.layout));
    });
    on<SwitchGridSize>((event, emit) {
      emit(state.copyWith(size: event.size));
    });
  }
}

class _LauncherState extends State<Launcher> {
  final menuController = FlyoutController();
  final itemsAttachKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridLayoutSizeBloc, GridLayoutState>(
        builder: (context, state) {
      return ScaffoldPage.withPadding(
        header: PageHeader(
            title: Text('Launcher'),
            commandBar: FlyoutTarget(
              controller: menuController,
              child: CommandBar(
                primaryItems: [
                  CommandBarButton(
                    icon: Icon(FluentIcons.add),
                    label: Text('Add'),
                    onPressed: () {
                      log("launch");
                    },
                  ),
                  CommandBarButton(
                    icon: Icon(FluentIcons.edit),
                    label: Text('Edit'),
                    onPressed: () {},
                  ),
                  CommandBarButton(
                    icon: Icon(FluentIcons.delete),
                    label: Text('Delete'),
                    onPressed: () {},
                  ),
                  CommandBarButton(
                    icon: Icon(FluentIcons.filter),
                    label: Text('Filter'),
                    onPressed: () {
                      menuController.showFlyout(
                        autoModeConfiguration: FlyoutAutoConfiguration(
                          preferredMode: FlyoutPlacementMode.topCenter,
                        ),
                        barrierDismissible: true,
                        dismissOnPointerMoveAway: false,
                        dismissWithEsc: true,
                        navigatorKey: rootNavigatorKey.currentState,
                        builder: (context) {
                          var repeat = true;
                          var shuffle = false;

                          return StatefulBuilder(builder: (context, setState) {
                            return MenuFlyout(items: [
                              MenuFlyoutItem(
                                text: const Text('Reset'),
                                onPressed: () {
                                  setState(() {
                                    repeat = false;
                                    shuffle = false;
                                  });
                                },
                              ),
                              const MenuFlyoutSeparator(),
                              ...GridLayout.values.map((e) {
                                return MenuFlyoutItem(
                                  text: Text(e.name),
                                  leading: Icon(
                                    e == GridLayout.grid
                                        ? FluentIcons.grid_view_small
                                        : e == GridLayout.list
                                            ? FluentIcons.list_mirrored
                                            : FluentIcons.grid_view_large,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      context
                                          .read<GridLayoutSizeBloc>()
                                          .add(SwitchLayout(e));
                                    });
                                  },
                                );
                              }),
                              const MenuFlyoutSeparator(),
                              ToggleMenuFlyoutItem(
                                text: const Text('Repeat'),
                                value: repeat,
                                onChanged: (v) {
                                  setState(() => repeat = v);
                                },
                              ),
                              ToggleMenuFlyoutItem(
                                text: const Text('Shuffle'),
                                value: shuffle,
                                onChanged: (v) {
                                  setState(() => shuffle = v);
                                },
                              ),
                              const MenuFlyoutSeparator(),
                              ...List.generate(GridLayoutSize.values.length, (index) {
                                return RadioMenuFlyoutItem(
                                  trailing: Icon([
                                    FluentIcons.grid_view_small ,
                                    FluentIcons.grid_view_medium,
                                    FluentIcons.grid_view_large,
                                  ][index]),
                                  text: Text([
                                    'Small icons',
                                    'Medium icons',
                                    'Large icons',
                                  ][index]),
                                  value: index,
                                  groupValue: state.size.index,
                                  onChanged: (v) {
                                    BlocProvider.of<GridLayoutSizeBloc>(context).add(
                                        SwitchGridSize(GridLayoutSize.values[v])
                                    );
                                  },
                                );
                              }),
                            ]);
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            )
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        content:
            state.layout == GridLayout.grid ? GridView(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: state.size.value,
            childAspectRatio: 1.0,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          addAutomaticKeepAlives: true,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            for (int i = 0; i < 50; i++)
              AppCard(
                title: "god of game",
                description: "a test game ",
                imageUrl: "",
                subtitle: "a test game ",
                author: "a test game ",
                version: "a test game ",
                license: "a test game ",
                playingTime: "a test game ",
                launch: () {
                  log("launch");
                },
              ),
          ],
        ) : ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < 50; i++)
                  ListTile.selectable(
                    title: Text("god of game"),
                    subtitle: Text("a test game "),
                    leading: SizedBox.fromSize(
                        size: Size(60, 60),
                      child: Image.network(
                        "",
                      ),
                    ),
                    trailing: Icon(FluentIcons.more),
                    onPressed: () {
                      log("launch");
                    },
                  )
              ]
            ),
      );
    });
  }
}
