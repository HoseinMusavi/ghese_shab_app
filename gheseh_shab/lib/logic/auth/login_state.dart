import 'package:dio/dio.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  List<Object> get props => [error];
  _onResetLoginState() {
    // Reset the state to initial
    return LoginInitial();
  }
}

class LoginSuccessWithToken extends LoginState {
  final String token;
  AuthRepository authRepository = AuthRepository(
    dio: Dio(BaseOptions(baseUrl: 'https://qesseyeshab.ir/api')),
  );

  // Constructor
  LoginSuccessWithToken(this.token) {
    authRepository.saveToken(token);
  }

  // Removed the duplicate constructor
}

class RegisterNeeded extends LoginState {
  final String phoneNumber;

  RegisterNeeded(this.phoneNumber);
}

class LoginAlready extends LoginState {
  final String phoneNumber;

  LoginAlready(this.phoneNumber);
}

class VerifyCodeSuccess extends LoginState {
  final String message;

  VerifyCodeSuccess(this.message);
}

class VerifyCodeFailure extends LoginState {
  final String message;

  VerifyCodeFailure(this.message);
}

class ForgotPasswordLoading extends LoginState {}

class ForgotPasswordSuccess extends LoginState {}

class ForgotPasswordFailure extends LoginState {
  final String error;

  ForgotPasswordFailure(this.error);
}
