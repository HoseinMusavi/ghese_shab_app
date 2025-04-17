import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:gheseh_shab/data/repositories/story_repository.dart';
import 'package:gheseh_shab/logic/story_bloc/story_event.dart';
import 'package:gheseh_shab/logic/story_bloc/story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository storyRepository;

  StoryBloc({required this.storyRepository}) : super(StoryInitial()) {
    on<FetchStoriesEvent>(_onFetchStories);
    on<UpdateStoriesEvent>(_onUpdateStories);
  }

  Future<void> _onFetchStories(
      FetchStoriesEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoading());
    try {
      final stories = await storyRepository.fetchStories(
        search: event.search,
        filter: event.filter,
      );
      emit(StoryLoaded(stories: stories));
    } catch (e) {
      emit(StoryError(message: e.toString()));
    }
  }

  Future<void> _onUpdateStories(
      UpdateStoriesEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoading());
    try {
      final stories = await storyRepository.fetchStories(
        search: event.search,
        filter: event.filter,
      );
      emit(StoryLoaded(stories: stories));
    } catch (e) {
      emit(StoryError(message: e.toString()));
    }
  }
}
