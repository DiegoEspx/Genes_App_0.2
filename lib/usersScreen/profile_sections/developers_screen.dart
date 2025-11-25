import 'package:flutter/material.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:genesapp/widgets/app_colors.dart';

class DevelopersScreen extends StatelessWidget {
  const DevelopersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: 'Desarrolladores',
        color: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Equipo de Desarrollo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Conoce a las personas detrás de GenesApp',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Diego Alejandro
            _buildDeveloperCard(
              name: 'Diego Alejandro Guerrero España',
              role: 'Desarrollador Full Stack',
              description:
                  'Especializado en desarrollo móvil con Flutter y backend con Python. Apasionado por la tecnología aplicada a la salud.',
              icon: Icons.person,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 20),

            // Sebastián
            _buildDeveloperCard(
              name: 'Sebastián Fajardo Delgado',
              role: 'Desarrollador Full Stack',
              description:
                  'Experto en inteligencia artificial y machine learning. Enfocado en crear soluciones innovadoras para el sector médico.',
              icon: Icons.person,
              color: AppColors.accentGreen,
            ),
            const SizedBox(height: 32),

            // Información de contacto
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.contact_mail,
                            color: AppColors.primaryBlue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Contacto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      Icons.email,
                      'Email',
                      'd.alejo.guerrero.e@gmail.com',
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.school,
                      'Institución',
                      'Universidad Cooperativa de Colombia',
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.code,
                      'Proyecto',
                      'Trabajo de Grado 2025',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Agradecimientos
            Center(
              child: Column(
                children: [
                  Text(
                    'Agradecimientos especiales',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A todos los profesionales de la salud que\nhan contribuido al desarrollo de esta aplicación',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String name,
    required String role,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.05), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Nombre
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),

              // Rol
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
