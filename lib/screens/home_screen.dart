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
            onPressed: (){
              
            }, 
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
              _bottomBatItem(Icons.filter_vintage_outlined, '滤镜', onPressed: (){
                Navigator.of(context).pushNamed('/filter');
              }),
              _bottomBatItem(Icons.tune, '调节', onPressed: (){
                Navigator.of(context).pushNamed('/adjust');
              }),
              _bottomBatItem(Icons.fit_screen_sharp, '背景', onPressed: (){
                Navigator.of(context).pushNamed('/fit');
              }),
              _bottomBatItem(Icons.border_color, '叠加', onPressed: (){
                Navigator.of(context).pushNamed('/tint');
              }),
              _bottomBatItem(Icons.blur_circular, '模糊', onPressed: (){
                Navigator.of(context).pushNamed('/blur');
              }),
              _bottomBatItem(Icons.text_fields, '文字', onPressed: (){
                Navigator.of(context).pushNamed('/text');
              }),
              _bottomBatItem(Icons.emoji_emotions_outlined, '贴纸', onPressed: (){
                Navigator.of(context).pushNamed('/stick');
              }),
              _bottomBatItem(Icons.draw, '画笔', onPressed: () {
                Navigator.of(context).pushNamed('/draw');
              }),
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