import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:gheseh_shab/data/repositories/coin_repository.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final CoinRepository coinRepository;

  CoinBloc(AuthRepository authRepository, {required this.coinRepository})
      : super(CoinInitial()) {
    on<BuyCoinsEvent>((event, emit) async {
      emit(CoinLoading());
      try {
        final payLink = await coinRepository.depositCoins(event.amount);
        emit(CoinSuccess(payLink));
      } catch (e) {
        emit(CoinFailure(e.toString()));
      }
    });
  }
}
