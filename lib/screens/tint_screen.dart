import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ndfl/helper/tints.dart';
import 'package:ndfl/model/Tint.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class TintScreen extends StatefulWidget {
  const TintScreen({super.key});

  @override
  State<TintScreen> createState() => _TintScreenState();
}

class _TintScreenState extends State<TintScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  late List<Tint> tints;
  int currentSelected = 0;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    tints = Tints().list();
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
                    child: Image.memory(
                      value.currentImage!,
                      color: tints[currentSelected].color.withOpacity(tints[currentSelected].opacity),
                      colorBlendMode: BlendMode.color,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                slider(
                  label: 'tint',
                  value: tints[currentSelected].opacity,
                  onChanged: (value) {
                    setState(() {
                      tints[currentSelected].opacity = value;
                    });
                  }
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: Colors.black,
        child: SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tints.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index){
              Tint tt = tints[index];
              return GestureDetector(
                onTap: () => {
                  setState(() {
                    currentSelected = index;
                  })
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  child: CircleAvatar(
                    backgroundColor: this.currentSelected == index ?  Colors.white : Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(2),
                       child: CircleAvatar(
                        backgroundColor: tt.color,
                      )
                    ),
                  ),
                ),
              );
          
            })
        ),
      ),
    );
  }


  Widget slider({label, value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      max: 1,
      min: 0,
      onChanged: onChanged,
    );
  }
}