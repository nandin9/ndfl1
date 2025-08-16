import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  double sigmaX = 0.1;
  double sigmaY = 0.1;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: const CloseButton(color: Colors.white),
        title: const Text('tint', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async{
              Uint8List? bitmap = await screenshotController.capture();
              imageProvider.changeImage(bitmap!);
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
          }, icon: const Icon(Icons.done))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: sigmaX,
                        sigmaY: sigmaY,
                        tileMode: TileMode.decal
                      ),
                      child: Image.memory(
                        value.currentImage!,
                        // color: tints[currentSelected].color.withOpacity(tints[currentSelected].opacity),
                        // colorBlendMode: BlendMode.color,
                      ),
                    )
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('X:', style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: slider(
                          label: 'tint',
                          value: sigmaX,
                          onChanged: (value) {
                            setState(() {
                              sigmaX = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Y:', style: TextStyle(color: Colors.white),),
                      Expanded(
                        child: slider(
                          label: 'tint',
                          value: sigmaY,
                          onChanged: (value) {
                            setState(() {
                              sigmaY = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: Colors.black,
      ),
    );
  }

  Widget slider({label, value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      max: 10,
      min: 0,
      onChanged: onChanged,
    );
  }
}