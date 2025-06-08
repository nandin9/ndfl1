import 'package:flutter/material.dart';
import 'package:ndfl/providers/app_image_provider.dart';
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
        primaryColor: Colors.blue
      ),
      routes: <String, WidgetBuilder> {
        '/' : (_) => const StartScrenn(),
        '/home' : (_) => const HomeScreen(),
      },
      initialRoute: '/',
      // home: const StartScrenn()
    );
  }
}
