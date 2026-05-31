import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TiendaTenisApp());
}

class TiendaTenisApp extends StatelessWidget {
  const TiendaTenisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tienda de Tenis',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}
