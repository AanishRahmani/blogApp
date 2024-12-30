import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final xfile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (xfile != null) {
      return File(xfile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
