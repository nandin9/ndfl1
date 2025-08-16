import 'dart:typed_data';

import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {

  double brightness = 0.0;
  double contrast = 0.0;
  double saturation = 0.0;
  double hue = 0.0;
  double sepia = 0.0;

  bool showBSlider = false;
  bool showCSlider = false;
  bool showSSlider = false;
  bool showHSlider = false;
  bool showSESlider = false;

  late AppImageProvider imageProvider;
  late ColorFilterGenerator colorFilterGenerator;
  ScreenshotController screenshotController = ScreenshotController();
  
  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
    super.initState();
  }

  void adjust({b, c, s, h, se}) {
    colorFilterGenerator = ColorFilterGenerator(name: 'Adjust', filters: 
      [
        ColorFilterAddons.brightness(b ?? brightness),
        ColorFilterAddons.contrast(c ?? contrast),
        ColorFilterAddons.saturation(s ?? saturation),
        ColorFilterAddons.hue(h ?? hue),
        ColorFilterAddons.sepia(se ?? sepia),
      ]
    );
  }

    void reset() {
      setState(() {
        brightness = 0.0;
        contrast = 0.0;
        hue = 0.0;
        sepia = 0.0;
        saturation = 0.0;
        adjust();
      });
    }

  void showSlider({b, c, s, h, se}) {
    setState(() {
      showBSlider = b != null ? true : false;
      showCSlider = c != null ? true : false;
      showSSlider = s != null ? true : false;
      showHSlider = h != null ? true : false;
      showSESlider = se != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(color: Colors.white),
        title: const Text('adjust', style: TextStyle(color: Colors.white)),
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
              builder: (BuildContext context, value, Widget? child){
                if (value.currentImage != null) {
                  return  Screenshot(
                    controller: screenshotController,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(colorFilterGenerator.matrix),
                      child: Image.memory(value.currentImage!)),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                }
              }
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showBSlider,
                        child: slider(
                          label: 'brightness',
                          value: brightness,
                          onChanged: (value) {
                            setState(() {
                              brightness = value;
                              adjust(b:brightness);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showCSlider,
                        child: slider(
                          label: 'contrast',
                          value: contrast,
                          onChanged: (value) {
                            setState(() {
                              contrast = value;
                              adjust(c: contrast);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showSSlider,
                        child: slider(
                          label: 'saturation',
                          value: saturation,
                          onChanged: (value) {
                            setState(() {
                              saturation = value;
                              adjust(s: saturation);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showHSlider,
                        child: slider(
                          label: 'hue',
                          value: hue,
                          onChanged: (value) {
                            setState(() {
                              hue = value;
                              adjust(h: hue);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showSESlider,
                        child: slider(
                          label: 'sepia',
                          value: sepia,
                          onChanged: (value) {
                            setState(() {
                              sepia = value;
                              adjust(se:sepia);
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      // adjust(b: 0.0, c: 0.0, s: 0.0, h: 0.0, se: 0.0);
                      reset();
                    });
                  }, 
                  child: const Text('重置', style: TextStyle(color: Colors.white),)
                )
              ],
            )
          )
        ],
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
                _bottomBatItem(Icons.brightness_4_rounded, '亮度', 
                  color: showBSlider ? Colors.blue : Colors.white,
                  onPressed: (){
                    showSlider(b: true);
                  }
                ),
                _bottomBatItem(Icons.contrast_rounded, '对比度', 
                  color: showCSlider ? Colors.blue : Colors.white,
                  onPressed: (){
                    showSlider(c: true);
                  }
                ),
                _bottomBatItem(Icons.water_drop_rounded, '饱和度', 
                  color: showSSlider ? Colors.blue : Colors.white,
                  onPressed: (){
                  showSlider(s: true);
                }),
                _bottomBatItem(Icons.filter_tilt_shift_rounded, 'HUE', 
                  color: showHSlider ? Colors.blue : Colors.white,
                  onPressed: (){
                   showSlider(h: true);
                }),
                _bottomBatItem(Icons.motion_photos_on_rounded, 'SEPIA',
                  color: showSESlider ? Colors.blue : Colors.white,
                  onPressed: (){
                   showSlider(se: true);
                }),
            ],),
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {Color? color, required onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color ?? Colors.white,),
            const SizedBox(height: 4.0),
            Text(title, style: TextStyle(color: color ?? Colors.white, fontSize: 13.0),)
          ],
        ),
      
      ),
    );
  }

  Widget slider({label, value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      max: 1,
      min: -1,
      onChanged: onChanged,
    );
  }
}