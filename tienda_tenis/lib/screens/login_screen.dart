import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'registro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoController = TextEditingController();

  final passwordController = TextEditingController();

  final api = ApiService();

  Future<void> login() async {
    final respuesta = await api.login(
      correo: correoController.text,
      password: passwordController.text,
    );
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("logueado", true);
    await prefs.setString("correo", correoController.text);

    if (respuesta["success"]) {
      final prefs = await SharedPreferences.getInstance();

      // Guardar información del usuario
      await prefs.setBool("logueado", true);
      await prefs.setString("correo", correoController.text);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(respuesta["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: correoController,
              decoration: const InputDecoration(labelText: "Correo"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: login, child: const Text("Ingresar")),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistroScreen()),
                );
              },
              child: const Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}
