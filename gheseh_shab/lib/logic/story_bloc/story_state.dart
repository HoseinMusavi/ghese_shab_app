import 'package:equatable/equatable.dart';
import 'package:gheseh_shab/data/models/story_model.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final List<StoryModel> stories;

  const StoryLoaded({required this.stories});

  @override
  List<Object?> get props => [stories];
}

class StoryError extends StoryState {
  final String message;

  const StoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
