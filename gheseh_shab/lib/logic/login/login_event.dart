import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendPhoneNumberEvent extends LoginEvent {
  final String phoneNumber;

  SendPhoneNumberEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
