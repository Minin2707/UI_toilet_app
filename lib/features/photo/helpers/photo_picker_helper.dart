import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:image_picker/image_picker.dart';

class PhotoPickerHelper {

  static Future<File?> pickImage() async {

    final picker = ImagePicker();

    final picked =
        await picker.pickImage(

      source: ImageSource.gallery,

      imageQuality: 75,
    );

    if (picked == null) {

      return null;
    }

    final targetPath =
        '${picked.path}.jpg';

    final compressed =
        await FlutterImageCompress.compressAndGetFile(

      picked.path,

      targetPath,

      quality: 80,

      format: CompressFormat.jpeg,
    );

    if (compressed == null) {

      return null;
    }

    return File(
      compressed.path,
    );
  }
}