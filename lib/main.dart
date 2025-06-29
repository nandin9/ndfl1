import 'package:flutter/material.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:ndfl/screens/crop_screen.dart';
import 'package:ndfl/screens/filter_screen.dart';
import 'package:ndfl/screens/home_screen.dart';
import 'package:ndfl/screens/start_screnn.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppImageProvider())
    ],
    child: MainApp(),
    )
    // const MainApp());
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ndfl',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF111111),
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.black,
          centerTitle: true,
        )
      ),
      routes: <String, WidgetBuilder> {
        '/' : (_) => const StartScrenn(),
        '/home' : (_) => const HomeScreen(),
        '/crop' : (_) => const CropScreen(),
        '/filter' : (_) => const FilterScreen(),
      },
      initialRoute: '/',
    );
  }
}
