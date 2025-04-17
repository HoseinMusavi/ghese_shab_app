abstract class LoginEvent {}

class SendPhoneNumberEvent extends LoginEvent {
  final String phoneNumber;

  SendPhoneNumberEvent(this.phoneNumber);
}

class VerifyCodeEvent extends LoginEvent {
  final String phoneNumber;
  final String code;

  VerifyCodeEvent(this.phoneNumber, this.code);
}

class ForgotPasswordEvent extends LoginEvent {
  final String phone;

  ForgotPasswordEvent(this.phone);
}

class ResetLoginStateEvent extends LoginEvent {}

class LoginWithPhoneAndPasswordEvent extends LoginEvent {
  final String phoneNumber;
  final String password;

  LoginWithPhoneAndPasswordEvent(this.phoneNumber, this.password);
}
