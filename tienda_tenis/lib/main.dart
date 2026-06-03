import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final logueado = prefs.getBool("logueado") ?? false;

  runApp(TiendaTenisApp(logueado: logueado));
}

class TiendaTenisApp extends StatelessWidget {
  final bool logueado;

  const TiendaTenisApp({super.key, required this.logueado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tienda de Tenis',
      theme: ThemeData(primarySwatch: Colors.blue),

      home: logueado ? const HomeScreen() : const LoginScreen(),
    );
  }
}
