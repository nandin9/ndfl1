import 'package:flutter/material.dart';
import 'package:ndfl/providers/app_image_provider.dart';
import 'package:ndfl/screens/adjust_screen.dart';
import 'package:ndfl/screens/blur_screen.dart';
import 'package:ndfl/screens/crop_screen.dart';
import 'package:ndfl/screens/filter_screen.dart';
import 'package:ndfl/screens/fit_screeen.dart';
import 'package:ndfl/screens/home_screen.dart';
import 'package:ndfl/screens/start_screnn.dart';
import 'package:ndfl/screens/tint_screen.dart';
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
        ),
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
        )
      ),
      routes: <String, WidgetBuilder> {
        '/' : (_) => const StartScrenn(),
        '/home' : (_) => const HomeScreen(),
        '/crop' : (_) => const CropScreen(),
        '/filter' : (_) => const FilterScreen(),
        '/adjust' : (_) => const AdjustScreen(),
        '/fit' : (_) => const FitScreeen(),
        '/tint' : (_) => const TintScreen(),
        '/blur' : (_) => const BlurScreen(),
      },
      initialRoute: '/',
    );
  }
}
