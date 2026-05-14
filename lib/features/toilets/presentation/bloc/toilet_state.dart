import '../../data/models/toilet_dto.dart';

abstract class ToiletState {}

class ToiletInitial extends ToiletState {}

class ToiletLoading extends ToiletState {}

class ToiletLoaded extends ToiletState {
  final List<ToiletDto> toilets;

  ToiletLoaded(this.toilets);
}

class ToiletError extends ToiletState {
  final String message;

  ToiletError(this.message);
}