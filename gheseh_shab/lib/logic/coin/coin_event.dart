part of 'coin_bloc.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class BuyCoinsEvent extends CoinEvent {
  final int amount;

  const BuyCoinsEvent(this.amount);

  @override
  List<Object> get props => [amount];
}
