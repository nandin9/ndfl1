import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ndfl/helper/filters.dart';
import 'package:ndfl/model/filter.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  late Filter currentFiler;
  late List<Filter> filters;
  late AppImageProvider imageProvider;
  ScreenshotController controller = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFiler = filters[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(color: Colors.white),
        title: const Text('filter', style: TextStyle(color: Colors.white)),
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
              return Screenshot(
                controller: controller,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(currentFiler.matrix),
                  child: Image.memory(value.currentImage!),
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
        height: 108.0,
        color: Colors.black,
        child: SafeArea(
          child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (BuildContext context, int index) { 
                Filter filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                currentFiler = filter; 
                              });
                            },
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(filter.matrix),
                              child: Image.memory(value.currentImage!,)
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 4), 
                      Text(filter.filterName, style: const TextStyle(color: Colors.white, fontSize: 12))
                    ],
                    
                  ),
                );
              
              },

            
            );
          }
        )
        ),
      ),
    );
  }
  
  Widget _bottomBatItem(Text text, {required onPressed}) {
    return Consumer<AppImageProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(currentFiler.matrix),
                    child: Image.memory(value.currentImage!,
                      fit: BoxFit.fitHeight,
                      width: 40,
                      // height: 40,
                    )
                  ) 
                ),
                text
              ],
            )
          ),
        );
      }
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