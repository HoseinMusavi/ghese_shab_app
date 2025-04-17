import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckUserLoginEvent extends UserEvent {}

class UpdateUserInfoEvent extends UserEvent {
  final Map<String, dynamic> userInfo;
  final XFile? image;

  UpdateUserInfoEvent({required this.userInfo, this.image});

  @override
  List<Object?> get props => [userInfo, image];
}
