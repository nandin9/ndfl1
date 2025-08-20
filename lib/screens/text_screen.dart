import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:ndfl/helper/fonts.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:text_editor/text_editor.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  LindiController controller = LindiController();

  bool showEditor = false;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ 
        Scaffold(
         appBar: AppBar(
          leading: const CloseButton(color: Colors.white),
          title: const Text('text', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              color: Colors.white,
              onPressed: () async{
                Uint8List? bitmap = await controller.saveAsUint8List();
                imageProvider.changeImage(bitmap!);
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
            }, icon: const Icon(Icons.done))
          ],
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              showEditor = true;
            });
          },
          child: Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child){
                if (value.currentImage != null) {
                  return LindiStickerWidget(
                    controller: controller,
                    child: Image.memory(value.currentImage!),
                );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 80,
          color: Colors.transparent,
        ),
        ),
        if (showEditor)
        Scaffold(
          backgroundColor: Colors.black87,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextEditor(
                fonts: Fonts().list(),
                // paletteColors: colors,
                onEditCompleted: (style, align, text){
                  setState(() {
                    showEditor = false;
                    if (text.isNotEmpty) {
                      controller.addWidget(Text(text, textAlign: align, style: style));
                    }
                  });
                },
                // text: text,
                textStyle: const TextStyle(color: Colors.white),
                minFontSize: 10,
                maxFontSize: 50,
              ),
            ),
          ),
        )
        ]
    );
  }
}