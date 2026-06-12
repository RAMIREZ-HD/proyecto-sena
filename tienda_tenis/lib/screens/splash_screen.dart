import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color accentColor = Color(0xFF00C9A7);

  @override
  void initState() {
    super.initState();
    _navegarAlProximo();
  }

  Future<void> _navegarAlProximo() async {
    // Esperar 3 segundos
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Leer el estado de sesión
    final prefs = await SharedPreferences.getInstance();
    final logueado = prefs.getBool("logueado") ?? false;

    if (!mounted) return;

    // Redirigir según el estado
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => logueado ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),

            // Loading indicator
            const CircularProgressIndicator(
              color: accentColor,
              strokeWidth: 2.5,
            ),
            const SizedBox(height: 30),

            // Texto
            const Text(
              'Tienda de Tenis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cargando...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
