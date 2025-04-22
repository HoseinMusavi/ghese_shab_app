part of 'coin_bloc.dart';

abstract class CoinState extends Equatable {
  const CoinState();

  @override
  List<Object> get props => [];
}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinSuccess extends CoinState {
  final String payLink;

  const CoinSuccess(this.payLink);

  @override
  List<Object> get props => [payLink];
}

class CoinFailure extends CoinState {
  final String error;

  const CoinFailure(this.error);

  @override
  List<Object> get props => [error];
}
