import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/toilet_repository.dart';

import 'toilet_event.dart';
import 'toilet_state.dart';

class ToiletBloc
    extends Bloc<ToiletEvent, ToiletState> {

  final ToiletRepository repository;

  ToiletBloc(
    this.repository,
  ) : super(
          ToiletInitial(),
        ) {

    on<LoadToiletsEvent>(
      _onLoadToilets,
    );

    on<CreateToiletEvent>(
      _onCreateToilet,
    );

    on<ApproveToiletEvent>(
      _onApproveToilet,
    );

    on<ReportToiletEvent>(
      _onReportToilet,
    );
  }

  Future<void> _onLoadToilets(
    LoadToiletsEvent event,
    Emitter<ToiletState> emit,
  ) async {

    emit(
      ToiletLoading(),
    );

    try {

      final toilets =
          await repository.getToilets(

                  latitude: event.latitude,

                  longitude: event.longitude,

                  approvedOnly:
                      event.approvedOnly,

                  accessibleOnly:
                      event.accessibleOnly,

                  accessType:
                      event.accessType,
                );

      emit(
        ToiletLoaded(
          toilets,
        ),
      );

    } catch (e) {

      emit(
        ToiletError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onApproveToilet(
    ApproveToiletEvent event,
    Emitter<ToiletState> emit,
  ) async {

    try {

      await repository.approveToilet(
        event.toiletId,
      );

      final toilets =
          await repository.getToilets(
        latitude: event.reloadLatitude,
        longitude: event.reloadLongitude,
      );

      emit(
        ToiletLoaded(
          toilets,
        ),
      );

    } catch (e) {

      emit(
        ToiletError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onReportToilet(
    ReportToiletEvent event,
    Emitter<ToiletState> emit,
  ) async {

    try {

      await repository.reportToilet(
        event.toiletId,
      );

      final toilets =
          await repository.getToilets(

        latitude: event.reloadLatitude,

        longitude: event.reloadLongitude,
      );

      emit(
        ToiletLoaded(
          toilets,
        ),
      );

    } catch (e) {

      emit(
        ToiletError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateToilet(
    CreateToiletEvent event,
    Emitter<ToiletState> emit,
  ) async {

    try {

      await repository.createToilet(
        event.request,
      );

      final toilets =
          await repository.getToilets(
        latitude: event.reloadLatitude,
        longitude: event.reloadLongitude,
      );

      emit(
        ToiletLoaded(
          toilets,
        ),
      );

    } catch (e) {

      emit(
        ToiletError(
          e.toString(),
        ),
      );
    }
  }
}