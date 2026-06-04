import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';

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

    on<LeaveFeedbackEvent>(
      _onLeaveFeedback,
    );

    on<ReportToiletEvent>(
      _onReportToilet,
    );

    on<ConfirmToiletEvent>(
      _onConfirmToilet,
    );
  }

  Future<void> _onLoadToilets(
    LoadToiletsEvent event,
    Emitter<ToiletState> emit,
  ) async {

    if (state is! ToiletLoaded) {

      emit(
        ToiletLoading(),
      );
    }

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

    } on AppException catch (e) {

      emit(
        ToiletLoadFailed(
          e.code,
        ),
      );

    } catch (e) {

      emit(
        ToiletLoadFailed(
          'UNKNOWN_ERROR',
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

            latitude:
                event.reloadLatitude,

            longitude:
                event.reloadLongitude,
          );

      emit(
        ToiletLoaded(

          toilets,

          uiMessageCode:
              'APPROVE_SUCCESS',
        ),
      );

    } on AppException catch (e) {

      _emitUiError(
        emit,
        e.code,
        e.retryAfterSeconds,
      );

    } catch (e) {

      _emitUiError(
        emit,
        'UNKNOWN_ERROR',
        null,
      );
    }
  }

  Future<void> _onConfirmToilet(
    ConfirmToiletEvent event,
    Emitter<ToiletState> emit,
  ) async {

    try {

      await repository.confirmToilet(
        event.toiletId,
      );

      final toilets =
          await repository.getToilets(

        latitude:
            event.reloadLatitude,

        longitude:
            event.reloadLongitude,
      );

      emit(
        ToiletLoaded(
          toilets,
        ),
      );

    } on AppException catch (e) {

      _emitUiError(
        emit,
        e.code,
        e.retryAfterSeconds,
      );

    } catch (e) {

      _emitUiError(
        emit,
        'UNKNOWN_ERROR',
        null,
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

        latitude:
            event.reloadLatitude,

        longitude:
            event.reloadLongitude,
      );

      emit(
        ToiletLoaded(
          toilets,
          uiMessageCode: 'REPORT_SUCCESS',
        ),
      );

    } on AppException catch (e) {

      _emitUiError(
        emit,
        e.code,
        e.retryAfterSeconds,
      );

    } catch (e) {

      _emitUiError(
        emit,
        'UNKNOWN_ERROR',
        null,
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

        latitude:
            event.reloadLatitude,

        longitude:
            event.reloadLongitude,
      );

      emit(
        ToiletLoaded(
          toilets,
          uiMessageCode: 'CREATE_SUCCESS',
        ),
      );

    } on AppException catch (e) {

      _emitUiError(
        emit,
        e.code,
        e.retryAfterSeconds,
      );

    } catch (e) {

      _emitUiError(
        emit,
        'UNKNOWN_ERROR',
        null,
      );
    }
  }

  Future<void> _onLeaveFeedback(

    LeaveFeedbackEvent event,

    Emitter<ToiletState> emit,
  ) async {

    try {

      await repository.leaveFeedback(

        event.toiletId,

        event.type,
      );

      final toilets =
          await repository.getToilets(

        latitude:
            event.reloadLatitude,

        longitude:
            event.reloadLongitude,
      );

      emit(
        ToiletLoaded(
          toilets,
        ),
      );

    } on AppException catch (e) {

      _emitUiError(
        emit,
        e.code,
        e.retryAfterSeconds,
      );

    } catch (e) {

      _emitUiError(
        emit,
        'UNKNOWN_ERROR',
        null,
      );
    }
  }

  void _emitUiError(

    Emitter<ToiletState> emit,

    String code,

    int? retryAfterSeconds,
  ) {

    final currentState =
        state;

    if (currentState
        is ToiletLoaded) {

      emit(

        ToiletLoaded(

          currentState.toilets,

          uiMessageCode: code,

          retryAfterSeconds:
                    retryAfterSeconds,
        ),
      );
    }
  }
}