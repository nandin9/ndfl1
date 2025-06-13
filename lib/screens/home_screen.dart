import 'package:flutter/material.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("photo editor", style: TextStyle(color: Colors.white)),
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          TextButton(
            onPressed: (){}, 
            child: const Text('保存', style: TextStyle(color: Colors.white, fontSize: 15.0),),
            
          )
        ],
      ),

      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child){
            if (value.currentImage != null) {
              return Image.memory(value.currentImage!);
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
              _bottomBatItem(Icons.crop_rotate, '裁剪', onPressed: (){
                Navigator.of(context).pushNamed('/crop');

              }),
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
}