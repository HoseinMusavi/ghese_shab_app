import 'package:equatable/equatable.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchStoriesEvent extends StoryEvent {
  final String? search;
  final String? filter;

  const FetchStoriesEvent({this.search, this.filter});

  @override
  List<Object?> get props => [search, filter];
}

class UpdateStoriesEvent extends StoryEvent {
  final String? search;
  final String? filter;

  const UpdateStoriesEvent({this.search, this.filter});

  @override
  List<Object?> get props => [search, filter];
}
