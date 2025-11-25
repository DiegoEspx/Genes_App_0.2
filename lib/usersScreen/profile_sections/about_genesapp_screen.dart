import 'package:flutter/material.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:genesapp/widgets/app_colors.dart';

class AboutGenesAppScreen extends StatelessWidget {
  const AboutGenesAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: 'Acerca de GenesApp',
        color: AppColors.accentGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo y nombre
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.accentGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.biotech,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'GenesApp',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Versión 1.0.0',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Descripción
            _buildInfoCard(
              icon: Icons.info_outline,
              title: '¿Qué es GenesApp?',
              content:
                  'GenesApp es una aplicación móvil diseñada para democratizar el acceso a herramientas de predicción genética y facilitar la colaboración entre profesionales de la salud.',
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 16),

            // Misión
            _buildInfoCard(
              icon: Icons.flag_outlined,
              title: 'Nuestra Misión',
              content:
                  'Proporcionar herramientas de análisis genético accesibles y precisas que ayuden a los profesionales de la salud a tomar decisiones informadas para mejorar la atención médica.',
              color: AppColors.accentGreen,
            ),
            const SizedBox(height: 16),

            // Visión
            _buildInfoCard(
              icon: Icons.visibility_outlined,
              title: 'Nuestra Visión',
              content:
                  'Ser la plataforma líder en América Latina para el análisis predictivo genético, integrando inteligencia artificial y medicina personalizada.',
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 16),

            // Características
            _buildFeaturesCard(),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Desarrollado con ❤️ en Colombia',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2025 GenesApp',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    color: AppColors.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star_outline,
                    color: AppColors.accentGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Características Principales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureItem('Predicción Williams con IA'),
            _buildFeatureItem('Publicación de artículos médicos'),
            _buildFeatureItem('Historial de predicciones'),
            _buildFeatureItem('Verificación de médicos'),
            _buildFeatureItem('Interfaz intuitiva y moderna'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.accentGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
