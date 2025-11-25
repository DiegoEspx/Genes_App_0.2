import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genesapp/adminScreen/admin_dashboard_screen.dart';
import 'package:genesapp/adminScreen/verificacion_screen.dart';
import 'package:genesapp/medicScreen/viewArticles.dart';
import 'package:genesapp/pacientScreen/paciente.dart';
import 'package:genesapp/usersScreen/perfil.dart';
import 'package:genesapp/usersScreen/williams_predict/williamspredict.dart';
import 'package:genesapp/usersScreen/williamspredict2.dart';
import 'package:genesapp/login.dart';
import 'package:genesapp/widgets/app_colors.dart';

class RoleBasedDrawer extends StatelessWidget {
  final String? role;

  const RoleBasedDrawer({super.key, required this.role});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Limpiar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_email');

      // Cerrar sesión de Google (sin romper si falla)
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}

      // Cerrar sesión de Firebase
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      // Forzar cierre de sesión
      await FirebaseAuth.instance.signOut();
    }

    // Navegar al login
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header con gradiente
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.accentGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/genesapp_logo_text.png',
                height: 70,
                fit: BoxFit.contain,
                color: Colors.white,
                errorBuilder:
                    (context, error, stackTrace) => const Text(
                      'GenesApp',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
              ),
            ),
          ),
          // Lista de opciones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                if (role == 'admin') ...[
                  _buildSectionHeader('ADMINISTRACIÓN'),
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard_rounded,
                    text: 'Panel de Control',
                    color: Colors.orange,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminDashboardScreen(),
                          ),
                        ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.verified_user_rounded,
                    text: 'Verificaciones',
                    color: Colors.orange,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminVerificacionPendiente(),
                          ),
                        ),
                  ),
                  const Divider(indent: 20, endIndent: 20),
                ],
                if (role == 'doctor') ...[
                  _buildSectionHeader('MÉDICO'),
                  _buildDrawerItem(
                    context,
                    icon: Icons.library_books_rounded,
                    text: 'Publicaciones',
                    color: AppColors.primaryBlue,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VerArticulosScreen(),
                          ),
                        ),
                  ),
                  const Divider(indent: 20, endIndent: 20),
                ],
                if (role == 'patient') ...[
                  _buildSectionHeader('PACIENTE'),
                  _buildDrawerItem(
                    context,
                    icon: Icons.health_and_safety_rounded,
                    text: 'Mi Panel',
                    color: Colors.pinkAccent,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        ),
                  ),
                  const Divider(indent: 20, endIndent: 20),
                ],
                _buildSectionHeader('HERRAMIENTAS'),
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics_rounded,
                  text: 'Predictividad Williams',
                  color: Colors.purple,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Williamspredict(),
                        ),
                      ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.science_rounded,
                  text: 'Williams Definitivo',
                  color: Colors.indigo,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Williamspredict2(),
                        ),
                      ),
                ),
                const Divider(indent: 20, endIndent: 20),
                _buildSectionHeader('CUENTA'),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_rounded,
                  text: 'Mi Perfil',
                  color: Colors.blueGrey,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout_rounded,
                  text: 'Cerrar Sesión',
                  color: Colors.redAccent,
                  onTap: () => _handleLogout(context),
                  isDestructive: true,
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text(
                  'GenesApp v0.2.0',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '© 2025 GenesApp Team',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: Colors.grey[400],
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: color.withOpacity(0.05),
    );
  }
}
