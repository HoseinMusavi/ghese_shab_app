import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class PageChangedState extends NavigationState {
  final int currentPageIndex;

  const PageChangedState(this.currentPageIndex);

  @override
  List<Object> get props => [currentPageIndex];
}
