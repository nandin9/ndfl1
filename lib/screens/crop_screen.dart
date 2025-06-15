import 'dart:typed_data';
import 'dart:ui' as ui;
// import 'dart:ui'

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {

  late AppImageProvider imageProvider;

  final controller = CropController(
    aspectRatio: null,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9)
  );

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(color: Colors.white),
        title: const Text('crop', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async{
              ui.Image bitmap = await controller.croppedBitmap();
              ByteData? data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
              Uint8List bytes = data!.buffer.asUint8List();
              imageProvider.changeImage(bytes);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
          }, icon: const Icon(Icons.done))
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child){
            if (value.currentImage != null) {
              // return Image.memory(value.currentImage!);
              return CropImage(
                image: Image.memory(value.currentImage!),
                controller: controller,
                paddingSize: 15.0,
                alwaysMove: true,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator()
              );
            }
          }
        ),
      ),

      bottomNavigationBar: Container(
        width: double.infinity,
        height: 96.0,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
              _bottomBatItemIcon(Icons.rotate_90_degrees_ccw_outlined, onPressed: (){
                controller.rotateLeft();
              }),
              _bottomBatItemIcon(Icons.rotate_90_degrees_cw_outlined, onPressed: (){
                controller.rotateRight();
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  width: 1, 
                  height: 24, 
                  color: Colors.white
                ),
              ),
              _bottomBatItem(
                const Text('Free', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = null;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
              _bottomBatItem(
                const Text('1:1', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = 1;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
              _bottomBatItem(
                const Text('4:3', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = 4/3;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
              _bottomBatItem(
                const Text('2:1', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = 2;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
              _bottomBatItem(
                const Text('19:6', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = 19/6;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
              _bottomBatItem(
                const Text('1:2', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = 0.5;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
              _bottomBatItem(
                const Text('3:4', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = 0.75;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
              _bottomBatItem(
                const Text('6:19', style: TextStyle(color: Colors.white),), 
                onPressed: (){
                  controller.aspectRatio = 6/19;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }
              ),
            ],),
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(Text text, {required onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: text
        )

      ),
    );
  }

  Widget _bottomBatItemIcon(IconData icon, {required onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Icon(icon, color: Colors.white,),
        )

      ),
    );
  }
}