import 'package:flutter/material.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:genesapp/widgets/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _profileVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: 'Configuración',
        color: AppColors.primaryBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de Notificaciones
          _buildSectionHeader('Notificaciones'),
          _buildSettingTile(
            icon: Icons.notifications,
            title: 'Notificaciones Push',
            subtitle: 'Recibir alertas y actualizaciones',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // TODO: Guardar preferencia en Firestore
              },
              activeColor: AppColors.accentGreen,
            ),
          ),
          const Divider(height: 32),

          // Sección de Privacidad
          _buildSectionHeader('Privacidad'),
          _buildSettingTile(
            icon: Icons.visibility,
            title: 'Perfil Visible',
            subtitle: 'Permitir que otros usuarios te encuentren',
            trailing: Switch(
              value: _profileVisible,
              onChanged: (value) {
                setState(() {
                  _profileVisible = value;
                });
                // TODO: Guardar preferencia en Firestore
              },
              activeColor: AppColors.accentGreen,
            ),
          ),
          const Divider(height: 32),

          // Sección de Cuenta
          _buildSectionHeader('Cuenta'),
          _buildSettingTile(
            icon: Icons.delete_forever,
            title: 'Eliminar Cuenta',
            subtitle: 'Eliminar permanentemente tu cuenta',
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showDeleteAccountDialog(),
            isDestructive: true,
          ),
          const SizedBox(height: 20),

          // Información de versión
          Center(
            child: Column(
              children: [
                Text(
                  'GenesApp',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Versión 1.0.0',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primaryBlue,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: trailing,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: const [
                Icon(Icons.warning, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Text('Eliminar Cuenta'),
              ],
            ),
            content: const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta?\n\n'
              'Esta acción es permanente y no se puede deshacer. '
              'Todos tus datos, publicaciones y predicciones serán eliminados.',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementar eliminación de cuenta
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad en desarrollo'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
