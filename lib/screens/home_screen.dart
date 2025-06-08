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
      backgroundColor: Colors.black12,
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
    );
  }
}