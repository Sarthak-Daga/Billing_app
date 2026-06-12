import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static Future<String?> compressAndSaveImage(String imagePath) async {
    final Directory appDir = await getApplicationDocumentsDirectory();

    final Directory photosDir = Directory('${appDir.path}/photos');

    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final String targetPath =
        '${photosDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      targetPath,
      quality: 25,
    );

    return compressedFile?.path;
  }
}
