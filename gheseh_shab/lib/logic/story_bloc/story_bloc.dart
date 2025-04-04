import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/repositories/story_repository.dart';
import 'package:gheseh_shab/logic/story_bloc/story_event.dart';
import 'package:gheseh_shab/logic/story_bloc/story_state.dart';

class StoryBloc extends Bloc<StoryEvent, Story_State> {
  final Story_Repository storyRepository;
  StoryBloc(this.storyRepository) : super(StoryInitial()) {
    on<FetchStoriesEvent>((event, emit) async {
      emit(StoryLoding());
      try {
        final stories = await storyRepository.fetchStories();
        emit(StoryLoded(stories));
      } catch (e) {
        emit(StoryError('خطا در بارگذاری داستان‌ها: $e'));
      }
    });
  }
}
