import 'package:equatable/equatable.dart';

abstract class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final String phone;
  final String firstName;
  final String lastName;
  final String password;
  final String code;
  final String inviteCode;

  RegisterUserEvent({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.code,
    this.inviteCode = '',
  });
}
