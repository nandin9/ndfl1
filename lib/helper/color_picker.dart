
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AppColorPicker {
  
  show(BuildContext context, {Color? backGroundColor, Uint8List? image, onPick}) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        Color tempColor = backGroundColor!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  enableAlpha: false,
                  hexInputBar: true,
                  pickerColor: backGroundColor,
                  onColorChanged: (changeColor){
                    tempColor = changeColor;
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    onPick(tempColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      }
    );
  }
}