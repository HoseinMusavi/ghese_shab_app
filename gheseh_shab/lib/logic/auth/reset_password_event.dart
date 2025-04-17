import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String phoneNumber;
  final String password;
  final String code;

  const ResetPasswordSubmitted({
    required this.phoneNumber,
    required this.password,
    required this.code,
  });

  @override
  List<Object> get props => [phoneNumber, password, code];
}
