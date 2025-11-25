import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'register.dart';
import 'package:genesapp/usersScreen/screens_guias/guias_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  bool _rememberMe = false;
  String _error = '';

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateBasedOnRole(user);
      });
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradiente teal del diseño original
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4FD1C5),
                  Color(0xFF81E6D9),
                  Color(0xFF48BB78),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Blur condicional (evita crash en x86)
          if (!kIsWeb && defaultTargetPlatform != TargetPlatform.linux)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),
            ),

          // Contenedor central con diseño original (texto blanco)
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white70, width: 1),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/genesappLogo-removebg-preview.png',
                        height: 80,
                        filterQuality: FilterQuality.none,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '¡Bienvenido a GenesApp! 👋',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _inputDecoration(
                          label: 'Correo electrónico',
                          icon: Icons.email,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _inputDecoration(
                          label: 'Contraseña',
                          icon: Icons.lock,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed:
                                () => setState(
                                  () => _obscureText = !_obscureText,
                                ),
                          ),
                        ),
                      ),
                      // Remember me checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged:
                                (value) => setState(
                                  () => _rememberMe = value ?? false,
                                ),
                            activeColor: Colors.white,
                            checkColor: Colors.teal,
                          ),
                          const Text(
                            'Recordar este correo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildButton(
                        text: 'Ingresar',
                        onPressed: _isLoading ? null : _signInWithEmail,
                        loading: _isLoading,
                      ),
                      const SizedBox(height: 12),
                      _buildOutlinedButton(
                        text: 'Crear cuenta',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      SignInButton(
                        Buttons.GoogleDark,
                        text: "Iniciar sesión con Google",
                        onPressed: _signInWithGoogle,
                      ),
                      if (_error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _error,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      TextButton(
                        onPressed: () async {
                          final scaffoldContext = context;
                          await GoogleSignIn().signOut();
                          if (mounted) {
                            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Listo, ahora puedes elegir otra cuenta",
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "¿Usar otra cuenta de Google?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white70),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1FD1AB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 8,
          shadowColor: Colors.black45,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child:
            loading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 280,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmail() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(
        () =>
            _error = 'Por favor completa todos los campos para iniciar sesión',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Guardar email si el usuario marcó "recordar"
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_email', _emailController.text.trim());
      } else {
        await prefs.remove('saved_email');
      }

      await _navigateBasedOnRole(userCredential.user);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ocurrió un error al iniciar sesión.';
      switch (e.code) {
        case 'user-not-found':
        case 'invalid-credential':
          errorMessage = 'Correo o contraseña incorrectos.';
          break;
        case 'wrong-password':
          errorMessage = 'Contraseña incorrecta.';
          break;
        case 'invalid-email':
          errorMessage = 'El formato del correo no es válido.';
          break;
        case 'user-disabled':
          errorMessage = 'Esta cuenta ha sido deshabilitada.';
          break;
        case 'too-many-requests':
          errorMessage = 'Demasiados intentos. Intenta más tarde.';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de conexión. Revisa tu internet.';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }
      setState(() => _error = errorMessage);
    } catch (_) {
      setState(() => _error = 'Ocurrió un error inesperado. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'email': user.email,
                'role': 'patient',
                'name': user.displayName ?? 'Usuario',
                'photoUrl': user.photoURL,
                'created_at': FieldValue.serverTimestamp(),
              });
        }

        await _navigateBasedOnRole(user);
      }
    } on PlatformException catch (e) {
      String msg = 'Error al iniciar con Google.';
      if (e.code == 'sign_in_failed') {
        msg = 'Error de configuración de Google (SHA-1). Contacta al soporte.';
      } else if (e.code == 'network_error') {
        msg = 'Error de conexión. Revisa tu internet.';
      }
      setState(() => _error = msg);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = 'Error de autenticación: ${e.message}');
    } catch (e) {
      setState(() => _error = 'No se pudo iniciar sesión con Google.');
      debugPrint('Error Google Sign-In: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateBasedOnRole(User? user) async {
    if (!mounted || user == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GuiasScreen()),
    );
  }
}
