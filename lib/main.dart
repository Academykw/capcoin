import 'package:capcoin/screen/splash_screen.dart';
import 'package:capcoin/services/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (_) => FavoritesService(),
        child: const MyApp())
      );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
