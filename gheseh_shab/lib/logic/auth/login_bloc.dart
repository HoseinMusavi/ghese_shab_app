import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/models/user_model.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<SendPhoneNumberEvent>(_onSendPhoneNumber);
    on<VerifyCodeEvent>(_onVerifyCode);
    on<LoginWithPhoneAndPasswordEvent>(_onLoginWithPhoneAndPassword);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetLoginStateEvent>(_onResetLoginState);
  }

  // ارسال شماره موبایل
  Future<void> _onSendPhoneNumber(
      SendPhoneNumberEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await authRepository.sendPhoneNumber(event.phoneNumber);
      if (response.statusCode == 200) {
        print("شماره موبایل ارسال شد" + response.data.toString());
        if (response.data['status'] == 'ok') {
          final action = response.data['action'];
          if (action == 'register') {
            emit(RegisterNeeded(event.phoneNumber));
          } else if (action == 'login') {
            emit(LoginAlready(event.phoneNumber));
          } else {
            emit(LoginFailure("پاسخ نامعتبر از سرور"));
          }
        } else if (response.data['status'] == 'error') {
          emit(LoginFailure(
              response.data['message'] ?? "خطا در ارسال شماره موبایل"));
        }
      } else {
        emit(LoginFailure(
            response.data['message'] ?? "خطا در ارسال شماره موبایل"));
      }
    } catch (e) {
      emit(LoginFailure("خطا: ${e.toString()}"));
    }
  }

  // تأیید کد
  Future<void> _onVerifyCode(
      VerifyCodeEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response =
          await authRepository.verifyCode(event.phoneNumber, event.code);
      if (response.statusCode == 200) {
        print('شماره  و کد ارسال شدن');
        print(response.data.toString());
        if (response.data['status'] == 'ok') {
          emit(VerifyCodeSuccess(event.phoneNumber));
        } else {
          emit(
              VerifyCodeFailure(response.data['message'] ?? "خطا در تأیید کد"));
        }
      } else {
        emit(VerifyCodeFailure(
            response.data['message'] ?? "عدم برقراری ارتباط"));
      }
    } catch (e) {
      emit(VerifyCodeFailure("خطا: ${e.toString()}"));
    }
  }

  // ورود با شماره تلفن و رمز عبور
  Future<void> _onLoginWithPhoneAndPassword(
      LoginWithPhoneAndPasswordEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response =
          await authRepository.login(event.phoneNumber, event.password);

      // print('rispons iss :' + response.toString());
      if (response['status'] == 'ok') {
        emit(LoginSuccessWithToken(response['token']));
        final user = UserModel.fromJson(response);
        print('user iss :' + user.toString());
        print('شماره و رمز عبور ارسال شدن');
      } else {
        emit(LoginFailure(response['message'] ?? "خطا در ورود"));
      }
    } catch (e) {
      emit(LoginFailure("خطا: ${e.toString()}"));
    }
  }

  // فراموشی رمز عبور
  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<LoginState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await authRepository.forgotPassword(event.phone);

      if (response.statusCode == 200) {
        emit(ForgotPasswordSuccess());
      } else {
        emit(ForgotPasswordFailure("خطا در ارسال درخواست فراموشی رمز عبور"));
      }
    } catch (e) {
      emit(ForgotPasswordFailure("خطا: ${e.toString()}"));
    }
  }

  // بازنشانی وضعیت لاگین
  void _onResetLoginState(
      ResetLoginStateEvent event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }
}
