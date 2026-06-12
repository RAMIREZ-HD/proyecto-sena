import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();
  final api = ApiService();

  bool _cargando = false;
  bool _verPassword = false;
  bool _verConfirmar = false;
  int _fuerzaPassword = 0; // 0-3

  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color accentColor = Color(0xFF00C9A7);

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_evaluarPassword);
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();
    super.dispose();
  }

  void _evaluarPassword() {
    final p = passwordController.text;
    int fuerza = 0;
    if (p.length >= 6) fuerza++;
    if (p.contains(RegExp(r'[A-Z]'))) fuerza++;
    if (p.contains(RegExp(r'[0-9]'))) fuerza++;
    setState(() => _fuerzaPassword = fuerza);
  }

  String get _fuerzaLabel {
    switch (_fuerzaPassword) {
      case 1:
        return "Débil";
      case 2:
        return "Media";
      case 3:
        return "Fuerte";
      default:
        return "";
    }
  }

  Color get _fuerzaColor {
    switch (_fuerzaPassword) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orange;
      case 3:
        return accentColor;
      default:
        return Colors.transparent;
    }
  }

  Future<void> registrar() async {
    // Validaciones
    if (nombreController.text.trim().isEmpty ||
        correoController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      _mostrarSnack("Por favor completa todos los campos", error: true);
      return;
    }

    if (!correoController.text.contains("@")) {
      _mostrarSnack("Ingresa un correo válido", error: true);
      return;
    }

    if (passwordController.text != confirmarPasswordController.text) {
      _mostrarSnack("Las contraseñas no coinciden", error: true);
      return;
    }

    if (passwordController.text.length < 6) {
      _mostrarSnack(
        "La contraseña debe tener al menos 6 caracteres",
        error: true,
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final respuesta = await api.registrarUsuario(
        nombre: nombreController.text.trim(),
        correo: correoController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;
      setState(() => _cargando = false);

      _mostrarSnack(respuesta["message"], error: !respuesta["success"]);

      if (respuesta["success"]) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      _mostrarSnack("Error de conexión. Intenta de nuevo.", error: true);
    }
  }

  void _mostrarSnack(String mensaje, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              error ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: error ? Colors.redAccent : accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Sección superior — branding
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 36,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Botón volver
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Crear cuenta",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Únete a la tienda de tenis 👟",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sección inferior — formulario
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo nombre
                          _Campo(
                            controller: nombreController,
                            label: "Nombre completo",
                            icono: Icons.person_outline,
                          ),
                          const SizedBox(height: 14),

                          // Campo correo
                          _Campo(
                            controller: correoController,
                            label: "Correo electrónico",
                            icono: Icons.email_outlined,
                            teclado: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 14),

                          // Campo contraseña
                          _Campo(
                            controller: passwordController,
                            label: "Contraseña",
                            icono: Icons.lock_outline,
                            obscure: !_verPassword,
                            sufijo: IconButton(
                              icon: Icon(
                                _verPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _verPassword = !_verPassword),
                            ),
                          ),

                          // Indicador de fuerza
                          if (passwordController.text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _fuerzaPassword / 3,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation(
                                        _fuerzaColor,
                                      ),
                                      minHeight: 5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _fuerzaLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _fuerzaColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 14),

                          // Campo confirmar contraseña
                          _Campo(
                            controller: confirmarPasswordController,
                            label: "Confirmar contraseña",
                            icono: Icons.lock_outline,
                            obscure: !_verConfirmar,
                            sufijo: IconButton(
                              icon: Icon(
                                _verConfirmar
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _verConfirmar = !_verConfirmar,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Botón registrar
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _cargando ? null : registrar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: accentColor
                                    .withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                                shadowColor: accentColor.withOpacity(0.4),
                              ),
                              child: _cargando
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      "Crear cuenta",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Ya tienes cuenta
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "¿Ya tienes cuenta? ",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  "Inicia sesión",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icono;
  final TextInputType teclado;
  final bool obscure;
  final Widget? sufijo;

  const _Campo({
    required this.controller,
    required this.label,
    required this.icono,
    this.teclado = TextInputType.text,
    this.obscure = false,
    this.sufijo,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono, color: const Color(0xFF1A1A2E), size: 20),
        suffixIcon: sufijo,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00C9A7), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
