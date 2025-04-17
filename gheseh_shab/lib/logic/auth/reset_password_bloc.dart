import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:gheseh_shab/logic/auth/reset_password_event.dart';
import 'package:gheseh_shab/logic/auth/reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository authRepository;

  ResetPasswordBloc({required this.authRepository})
      : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        final response = await authRepository.resetPassword(
          phone: event.phoneNumber,
          password: event.password,
          code: event.code,
        );
        if (response['status'] == 'ok') {
          emit(ResetPasswordSuccess(response['token']));
        } else {
          emit(ResetPasswordFailure(
              response['message'] ?? "خطا در بازنشانی رمز"));
        }
      } catch (e) {
        emit(ResetPasswordFailure("خطا: $e"));
      }
    });
  }
}
