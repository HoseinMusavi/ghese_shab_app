import 'package:bloc/bloc.dart';

import 'package:gheseh_shab/data/repositories/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<SendPhoneNumberEvent>(_onSendPhoneNumber);
  }

  Future<void> _onSendPhoneNumber(
      SendPhoneNumberEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading()); // نمایش حالت بارگذاری

    try {
      final response = await loginRepository.sendPhoneNumber(event.phoneNumber);
      print('response: ${response.data}');
      print('statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.data['status'].toString() == 'ok') {
          emit(LoginSuccess(response.data['message'].toString()));
        }

        if (response.data['status'].toString() == 'error') {
          emit(LoginFailure(response.data['message'].toString()));
        }
      } else {
        emit(LoginFailure("خطا در ارسال شماره موبایل"));
      }
    } catch (e) {
      emit(LoginFailure("خطا: ${e.toString()}"));
    }
  }
}
