import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class ChangePageEvent extends NavigationEvent {
  final int pageIndex;

  const ChangePageEvent(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}
