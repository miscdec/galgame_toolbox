
import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';

@immutable
abstract class LayoutEvent extends Equatable {
  const LayoutEvent();
}

@immutable
abstract class LayoutState {
  const LayoutState();
}

class LayoutInitial extends LayoutState {
  const LayoutInitial();
}

class LayoutLoaded<T> extends LayoutState {
  const LayoutLoaded({required this.entries});

  final T entries;
}