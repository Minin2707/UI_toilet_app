import '../../data/models/create_toilet_request.dart';

abstract class ToiletEvent {}

class LoadToiletsEvent
    extends ToiletEvent {

  final double latitude;
  final double longitude;
  final bool approvedOnly;
  final bool accessibleOnly;
  final String? accessType;

  LoadToiletsEvent({
    required this.latitude,
    required this.longitude,
    this.approvedOnly = false,
    this.accessibleOnly = false,
    this.accessType,
  });
}

class CreateToiletEvent
    extends ToiletEvent {

  final CreateToiletRequest request;

  final double reloadLatitude;
  final double reloadLongitude;

  CreateToiletEvent({
    required this.request,
    required this.reloadLatitude,
    required this.reloadLongitude,
  });
}

class ApproveToiletEvent
    extends ToiletEvent {

  final String toiletId;

  final double reloadLatitude;
  final double reloadLongitude;

  ApproveToiletEvent({
    required this.toiletId,
    required this.reloadLatitude,
    required this.reloadLongitude,
  });
}

class ReportToiletEvent
    extends ToiletEvent {

  final String toiletId;

  final double reloadLatitude;
  final double reloadLongitude;

  ReportToiletEvent({
    required this.toiletId,
    required this.reloadLatitude,
    required this.reloadLongitude,
  });
}