import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
      RegisterUserEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final response = await authRepository.register(
        phone: event.phone,
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
        code: event.code,
        inviteCode: event.inviteCode,
      );

      if (response['status'] == 'ok') {
        emit(RegisterSuccess(token: response['token']));
      } else {
        emit(RegisterFailure(response['message'] ?? "خطا در ثبت‌نام"));
      }
    } catch (e) {
      emit(RegisterFailure("خطا: ${e.toString()}"));
    }
  }
}
