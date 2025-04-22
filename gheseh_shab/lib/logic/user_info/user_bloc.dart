import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/repositories/user_repository.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  UserBloc({required this.userRepository, required this.authRepository})
      : super(UserInitial()) {
    on<CheckUserLoginEvent>(_onCheckUserLogin);
    on<UpdateUserInfoEvent>(_onUpdateUserInfo);
  }

  Future<void> _onCheckUserLogin(
      CheckUserLoginEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final token = await authRepository.getToken();
      if (token == null) {
        emit(UserLoggedOut());
        return;
      }

      // ارسال درخواست به API با توکن جدید
      final user = await userRepository.fetchUserInfo();
      emit(UserLoggedIn(user: user.toJson()));
    } catch (e) {
      emit(UserError("خطا در بررسی وضعیت ورود: $e"));
    }
  }

  Future<void> _onUpdateUserInfo(
      UpdateUserInfoEvent event, Emitter<UserState> emit) async {
    emit(UserUpdating());
    try {
      final updatedUser = await userRepository.updateAccount(
        firstName: event.userInfo['first_name'],
        lastName: event.userInfo['last_name'],
        birthday: event.userInfo['birthday'],
        gender: event.userInfo['gender'],
        country: event.userInfo['country'],
        province: event.userInfo['province'],
        city: event.userInfo['city'],
        image: event.image,
      );
      emit(UserUpdated(user: updatedUser));
    } catch (e) {
      emit(UserError("خطا در به‌روزرسانی اطلاعات: $e"));
    }
  }
}
