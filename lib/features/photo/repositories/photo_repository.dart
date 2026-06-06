import 'dart:io';

import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:http_parser/http_parser.dart';

import '../../../../core/api/api_client.dart';

import '../model/toilet_photo.dart';

import '../../../../core/errors/app_exception.dart';

class PhotoRepository {

  final Dio _dio =
      ApiClient.createDio();



 Future<void> uploadPhoto({
   required String toiletId,
   required File file,
 }) async {
   try {
     final formData = FormData.fromMap({
       'photo': await MultipartFile.fromFile(
         file.path,
         filename: 'photo.jpg',
         contentType: MediaType(
           'image',
           'jpeg',
         ),
       ),
     });

     await _dio.post(
       '/toilet-photos/$toiletId',
       data: formData,
       onSendProgress: (sent, total) {
         print('UPLOAD: $sent / $total');
       },
     );
   } on DioException catch (e) {
     final data = e.response?.data;

     if (data is Map<String, dynamic>) {
       throw AppException(
         code: data['code'] ?? 'UNKNOWN_ERROR',
         message: data['message'] ?? 'Unknown error',
       );
     }

     throw AppException(
       code: 'UNKNOWN_ERROR',
       message: e.message ?? 'Unknown error',
     );
   }
 }



  Future<List<ToiletPhoto>> getPhotos(
    String toiletId,
  ) async {

    final response = await _dio.get(
      '/toilet-photos/$toiletId',
    );

    final data =
        response.data as List;

    return data.map((json) {

      return ToiletPhoto.fromJson(
        json,
      );

    }).toList();
  }

  Future<Uint8List> loadPhotoBytes(
    String url,
  ) async {

    final response = await _dio.get<List<int>>(

      url,

      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    return Uint8List.fromList(
      response.data!,
    );
  }
}