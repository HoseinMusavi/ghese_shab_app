import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoggedIn extends UserState {
  final Map<String, dynamic> user;

  UserLoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserLoggedOut extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserUpdating extends UserState {}

class UserUpdated extends UserState {
  final Map<String, dynamic> user;

  UserUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}
