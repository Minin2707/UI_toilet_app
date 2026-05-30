import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/errors/app_exception.dart';

import '../models/toilet_dto.dart';
import '../models/create_toilet_request.dart';

class ToiletRepository {

  final Dio _dio = ApiClient.createDio();

  Future<List<ToiletDto>> getToilets({

    required double latitude,

    required double longitude,

    bool approvedOnly = false,

    bool accessibleOnly = false,

    String? accessType,
  }) async {

    final response = await _dio.get(
      '/toilets/nearby',

      queryParameters: {

        'lat': latitude,

        'lon': longitude,

        'radiusMeters': 5000,

        'limit': 200,

        if (approvedOnly)
          'approvedOnly': true,

        if (accessibleOnly)
          'accessibleOnly': true,

        if (accessType != null)
          'accessType': accessType,
      },
    );

    final data =
        response.data as List;

    return data
        .map(
          (json) =>
              ToiletDto.fromJson(json),
        )
        .toList();
  }

  Future<void> createToilet(
    CreateToiletRequest request,
  ) async {

    await _dio.post(
      '/toilets',
      data: request.toJson(),
    );
  }

  Future<void> approveToilet(
    String toiletId,
  ) async {

    try {

      await _dio.post(
        '/toilets/$toiletId/approve',
      );

    } on DioException catch (e) {


    print(e.response?.data);
    print(e.response?.statusCode);






      final data =
          e.response?.data;

      throw AppException(

        code:
            data['code'] ??
                'UNKNOWN_ERROR',

        message:
            data['message'] ??
                'Unknown error',
      );
    }
  }

  Future<void> reportToilet(
    String toiletId,
  ) async {

    try {

      await _dio.post(
        '/toilets/$toiletId/report',
      );

    } on DioException catch (e) {

      final data =
          e.response?.data;

      throw AppException(

        code:
            data['code'] ??
                'UNKNOWN_ERROR',

        message:
            data['message'] ??
                'Unknown error',
      );
    }
  }

  Future<void> confirmToilet(
    String toiletId,
  ) async {

    await _dio.post(
      '/toilets/$toiletId/confirm',
    );
  }

  Future<void> leaveFeedback(

    String toiletId,

    String type,
  ) async {

    await _dio.post(

      '/toilets/$toiletId/feedback',

      queryParameters: {
        'type': type,
      },
    );
  }
}