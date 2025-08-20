import 'dart:io';
import 'dart:typed_data';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndfl/helper/app_image_picker.dart';
import 'package:ndfl/helper/pixel_color_image.dart';
import 'package:ndfl/helper/textures.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../helper/color_picker.dart';
import '../model/Texture.dart' as t;

class FitScreeen extends StatefulWidget {
  const FitScreeen({super.key});

  @override
  State<FitScreeen> createState() => _FitScreeenState();
}

class _FitScreeenState extends State<FitScreeen> {
  late AppImageProvider imageProvider;
  ScreenshotController controller = ScreenshotController();

  Uint8List? backGroundImage;
  Color backGroundColor = Colors.white;

  late t.Texture currentTexture;
  late List<t.Texture> textures;

  int aspect_x = 1;
  int aspect_y = 1;

  double blur = 0;

  bool showR = true;
  bool showB = false;
  bool showC = false;
  bool showT = false;

  bool showBBackground = true;
  bool showCBackground = true;
  bool showTBackground = true;


  showActiveWidget({r, b, c, t}) {
    showR = r != null ? true : false;
    showC = c != null ? true : false;
    showB = b != null ? true : false;
    showT = t != null ? true : false;
    // setState(() {});
  }

  showBackgroundWidget({b, c, t}) {
    showBBackground = b != null ? true : false;
    showCBackground = c != null ? true : false;
    showTBackground = t != null ? true : false;
    // setState(() {});
  }


  @override
  void initState() {
    textures = Textures().list();
    currentTexture = textures[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(color: Colors.white),
        title: const Text('fit', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async{
              Uint8List? bitmap = await controller.capture();
              imageProvider.changeImage(bitmap!);
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
          }, icon: const Icon(Icons.done))
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child){
            if (value.currentImage != null) {
              backGroundImage ??= value.currentImage;
              return AspectRatio(
                aspectRatio: aspect_x/aspect_y,
                child: Screenshot(
                  controller: controller,
                  child: Stack(
                    children: [
                      if (showCBackground)
                        Container(color: backGroundColor),
                      if (showBBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(backGroundImage!)
                            )
                          ),
                        ).blurred(
                          colorOpacity: 0,
                          blur: blur
                        ),
                      if (showTBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(currentTexture.path!)
                            )
                          ),
                        ),
                      Center(child: Image.memory(value.currentImage!))
                    ]
                  ),
                ),
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
        height: 128.0,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Stack(children: [
                if (showR) ratioWidget(),
                if (showB) 
                  blurWidget(),
                if (showC) 
                  colorWidget(),
                if (showT) 
                  textureWidget(),
              ])),
              Row(
                children: [
                Expanded(
                  child: _bottomBatItem(Icons.aspect_ratio_outlined, 'Ratio', onPressed: (){
                    setState(() {
                      showActiveWidget(r: true);
                    });
                  }),
                ),
                Expanded(
                  child: _bottomBatItem(Icons.blur_circular_outlined, 'Blur', onPressed: (){
                    setState(() {
                      showBackgroundWidget(b: true);
                      showActiveWidget(b: true);
                    });
                  }),
                ),
                Expanded(
                  child: _bottomBatItem(Icons.color_lens_outlined, 'Color', onPressed: (){
                    setState(() {
                      showBackgroundWidget(c: true);
                      showActiveWidget(c: true);
                    });
                  }),
                ),
                Expanded(
                  child: _bottomBatItem(Icons.texture_outlined, 'Texture', onPressed: (){
                    setState(() {
                      showBackgroundWidget(t: true);
                      showActiveWidget(t: true);
                    });
                  }),
                ),
              ],),
            ],
          ),
        ),
      ),
    );
  }


  Widget _bottomBatItem(IconData icon, String title, {required onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white,),
            const SizedBox(height: 4.0),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 13.0),)
          ],
        ),
      
      ),
    );
  }

  Widget ratioWidget() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton(onPressed: (){
                  setState(() {
                    aspect_x = 1;
                    aspect_y = 1;
                  });
                }, child: Text('1:1')),
                TextButton(onPressed: (){
                  setState(() {
                    aspect_x = 3;
                    aspect_y = 2;
                  });
                }, child: Text('3:2')),
                TextButton(onPressed: (){
                  setState(() {
                    aspect_x = 2;
                    aspect_y = 3;
                  });
                }, child: Text('2:3')),
                TextButton(onPressed: (){
                  setState(() {
                    aspect_x = 4;
                    aspect_y = 3;
                  });
                }, child: Text('4:3')),
                TextButton(onPressed: (){
                  setState(() {
                    aspect_x = 3;
                    aspect_y = 4;
                  });
                }, child: Text('3:4')),
                TextButton(onPressed: (){
                  setState(() {
                    aspect_x = 16;
                    aspect_y = 9;
                  });
                }, child: Text('16:9')),
                TextButton(onPressed: (){
                  setState(() {
                    aspect_x = 9;
                    aspect_y = 16;
                  });
                }, child: Text('9:16')),
              ],
            ),
          ),
        ]
      ),
    );
  }

  Widget blurWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: (){
                APPImagePicker(source: ImageSource.gallery)
                  .pick(onPick: (File? image) async {
                      backGroundImage = await image!.readAsBytes();
                      setState(() {});
                  });
              }, 
              icon: const Icon(Icons.photo_library_outlined, color: Colors.white)
            ),
            Expanded(
              child: Slider(
                label: blur.toStringAsFixed(0),
                value: blur,
                max: 100,
                min: 0,
                onChanged: (value){
                  setState(() {
                    blur = value;
                  });
                }
              ), 
            )
          ],
        ),
      ),
    );
  }

  Widget colorWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: (){
                AppColorPicker().show(
                  context,
                  backgroundColor: backGroundColor,
                  onPick: (color) {
                    setState(() {
                      backGroundColor = color;
                    });
                  }
                );
              }, 
              icon: const Icon(Icons.color_lens_outlined, color: Colors.white)
            ),
            IconButton(
              onPressed: (){
                PixelColorImage().show(
                  context,
                  backgroundColor: backGroundColor,
                  image: backGroundImage,
                  onPick: (color) {
                    setState(() {
                      backGroundColor = color;
                    });
                  }
                );
              }, 
              icon: const Icon(Icons.colorize_outlined, color: Colors.white)
            ),
            
          ],
        ),
      ),
    );
  }

    Widget textureWidget() {
      return Container(
        color: Colors.black,
        child: Center(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: textures.length,
            itemBuilder: (BuildContext context, int index) { 
              t.Texture texture = textures[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              currentTexture = texture; 
                            });
                          },
                          child: Image.asset(texture.path!),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
        )
      ),
    );
  }
}