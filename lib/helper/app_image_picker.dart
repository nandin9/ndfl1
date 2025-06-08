import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class APPImagePicker {
  ImageSource source;
  APPImagePicker({required this.source});

  pick({onPick}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: source);

    if (pickedFile != null) {
      onPick(File(pickedFile.path));
    } else {
      onPick(null);
    } 
  }

}