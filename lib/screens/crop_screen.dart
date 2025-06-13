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

  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9)
  );

  @override
  void initState() {
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
            onPressed: (){

          }, icon: const Icon(Icons.done))
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child){
            if (value.currentImage != null) {
              // return Image.memory(value.currentImage!);
              return CropImage(
                image: Image.asset('assets/images/bg.jpg'),
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
              
              // _bottomBatItem(),
              // _bottomBatItem(),
              // _bottomBatItem(),
              // _bottomBatItem(),
              // _bottomBatItem(),
              // _bottomBatItem(),
            ],),
          ),
        ),
      ),
    );
  }
}