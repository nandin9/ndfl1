import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndfl/helper/app_image_picker.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class StartScrenn extends StatefulWidget {
  const StartScrenn({super.key});

  @override
  State<StartScrenn> createState() => _StartScrennState();
}

class _StartScrennState extends State<StartScrenn> {

  late AppImageProvider imageProvider;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // Expanded(
              //   child: Center(
              //     child: Text('photo placeholder'),
              //   )
              // ),
              
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          APPImagePicker(source: ImageSource.gallery)
                          .pick(onPick: (File? image) {
                            imageProvider.changeImage(image);
                            Navigator.of(context).pushReplacementNamed('/home');
                          });
                        },
                        child: const Text("Gallery")
                      ),
                      ElevatedButton(
                        onPressed: (){
                          APPImagePicker(source: ImageSource.camera)
                          .pick(onPick: (File? image) {
                            // print('[ImagePicker] picked image: ${image!.path}');
                            imageProvider.changeImage(image);
                            Navigator.of(context).pushReplacementNamed('/home');
                          });
                        },
                        child: const Text("Camera")
                      ),

                    ],
                  ),
                )
                
              )
            ],
          )
        ],
      )
    );
  }
}