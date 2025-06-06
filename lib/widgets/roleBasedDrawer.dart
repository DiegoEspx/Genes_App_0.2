import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genesapp/adminScreen/admin_dashboard_screen.dart';
import 'package:genesapp/adminScreen/verificacion_screen.dart';
import 'package:genesapp/medicScreen/articles.dart';
import 'package:genesapp/medicScreen/medico.dart';
import 'package:genesapp/medicScreen/viewArticles.dart';
import 'package:genesapp/pacientScreen/paciente.dart';
import 'package:genesapp/usersScreen/perfil.dart';
import 'package:genesapp/redirect/login.dart';
import 'package:genesapp/usersScreen/williams_predict/williamspredict.dart';
import 'package:genesapp/usersScreen/williamspredict2.dart';

class RoleBasedDrawer extends StatelessWidget {
  final String? role;

  const RoleBasedDrawer({super.key, required this.role});

  void _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/GenesApp2.png',
                height: 110,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Expanded(
            child: SafeArea(
              top: false,
              bottom: true,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (role == 'admin') ...[
                    _buildSectionLabel('ADMINISTRADOR'),
                    _buildListTile(
                      icon: Icons.admin_panel_settings,
                      color: Colors.blueAccent,
                      text: 'Panel administrativo',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminDashboardScreen(),
                            ),
                          ),
                    ),
                    _buildListTile(
                      icon: Icons.verified_user,
                      color: Colors.blueAccent,
                      text: 'Verificaciones Pendientes',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const AdminVerificacionPendiente(),
                            ),
                          ),
                    ),
                  ],
                  if (role == 'doctor') ...[
                    _buildSectionLabel('MÉDICO'),

                    _buildListTile(
                      icon: Icons.feed,
                      color: Colors.teal,
                      text: 'Publicaciones',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VerArticulosScreen(),
                            ),
                          ),
                    ),
                  ],
                  if (role == 'patient') ...[
                    _buildSectionLabel('PACIENTE'),
                    _buildListTile(
                      icon: Icons.favorite,
                      color: Colors.pinkAccent,
                      text: 'Panel de Paciente',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          ),
                    ),
                  ],
                  _buildSectionLabel('UTILIDADES'),
                  _buildListTile(
                    icon: Icons.analytics,
                    color: Colors.deepPurple,
                    text: 'Predictividad Williams',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Williamspredict(),
                          ),
                        ),
                  ),
                  const Divider(),
                  _buildListTile(
                    icon: Icons.batch_prediction,
                    color: Colors.indigo,
                    text: 'Williams Def',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Williamspredict2(),
                          ),
                        ),
                  ),
                  _buildListTile(
                    icon: Icons.person,
                    color: Colors.indigo,
                    text: 'Mi perfil',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        ),
                  ),
                  _buildListTile(
                    icon: Icons.logout,
                    color: Colors.redAccent,
                    text: 'Cerrar sesión',
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
