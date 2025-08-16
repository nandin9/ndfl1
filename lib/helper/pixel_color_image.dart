
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';

class PixelColorImage {
  
  show(BuildContext context, {Color? backGroundColor, Uint8List? image, onPick}) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        Color tempColor = backGroundColor!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pick a Color!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PixelColorPicker(child: Image.memory(image!), onChanged: (color) {
                    setState((){
                      tempColor = color;
                    });
                  }),
                  SizedBox(height: 8),
                  Container(
                    height: 80,
                    width: double.infinity,
                    color: tempColor,
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  }, 
                  child: const Text('Cancel')
                ),
                TextButton(
                  onPressed: (){
                    onPick(tempColor);
                    Navigator.of(context).pop();
                  }, 
                  child: const Text('Pick')
                ),
              ],
            );
          }
        );
      }
    );
  }
}