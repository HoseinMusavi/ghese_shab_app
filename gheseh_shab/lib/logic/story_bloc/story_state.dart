import 'package:gheseh_shab/data/models/story_model.dart';

abstract class Story_State {}

class StoryInitial extends Story_State {}

class StoryLoding extends Story_State {}

class StoryLoded extends Story_State {
  final List<StoryModel> storyList;
  StoryLoded(this.storyList);
}

class StoryError extends Story_State {
  final String error;
  StoryError(this.error);
}
