import '../../data/models/toilet_dto.dart';

abstract class ToiletState {}

class ToiletInitial
    extends ToiletState {}

class ToiletLoading
    extends ToiletState {}

class ToiletLoaded
    extends ToiletState {

  final List<ToiletDto> toilets;

  final String? uiMessageCode;

  final int? retryAfterSeconds;

  ToiletLoaded(

    this.toilets, {

    this.uiMessageCode,

    this.retryAfterSeconds,
  });
}

class ToiletLoadFailed
    extends ToiletState {

  final String code;

  ToiletLoadFailed(this.code);
}