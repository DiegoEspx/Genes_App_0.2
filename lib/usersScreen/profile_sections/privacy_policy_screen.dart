import 'package:flutter/material.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:genesapp/widgets/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: 'Política de Privacidad',
        color: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.privacy_tip,
                      size: 50,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Política de Privacidad',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Última actualización: Noviembre 2025',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Introducción
            _buildSection(
              title: '1. Introducción',
              content:
                  'GenesApp se compromete a proteger la privacidad de sus usuarios. Esta Política de Privacidad describe cómo recopilamos, usamos, almacenamos y protegemos su información personal de acuerdo con la Ley 1581 de 2012 de Colombia y demás normativas aplicables.',
            ),

            // Información que recopilamos
            _buildSection(
              title: '2. Información que Recopilamos',
              content:
                  'Recopilamos la siguiente información:\n\n'
                  '• Datos de identificación: nombre, correo electrónico, cédula (solo para médicos)\n'
                  '• Datos profesionales: institución médica, número ReTHUS (solo para médicos)\n'
                  '• Datos de uso: predicciones realizadas, artículos publicados\n'
                  '• Datos técnicos: dirección IP, tipo de dispositivo, sistema operativo',
            ),

            // Uso de la información
            _buildSection(
              title: '3. Uso de la Información',
              content:
                  'Utilizamos su información para:\n\n'
                  '• Proporcionar y mejorar nuestros servicios\n'
                  '• Verificar la identidad de profesionales médicos\n'
                  '• Generar predicciones y análisis genéticos\n'
                  '• Facilitar la publicación y visualización de artículos médicos\n'
                  '• Comunicarnos con usted sobre actualizaciones y notificaciones\n'
                  '• Cumplir con obligaciones legales',
            ),

            // Almacenamiento y seguridad
            _buildSection(
              title: '4. Almacenamiento y Seguridad',
              content:
                  'Sus datos se almacenan de forma segura en servidores de Firebase (Google Cloud Platform) con las siguientes medidas de seguridad:\n\n'
                  '• Cifrado de datos en tránsito y en reposo\n'
                  '• Autenticación de dos factores\n'
                  '• Controles de acceso estrictos\n'
                  '• Copias de seguridad regulares\n'
                  '• Monitoreo continuo de seguridad',
            ),

            // Compartir información
            _buildSection(
              title: '5. Compartir Información',
              content:
                  'NO compartimos, vendemos ni alquilamos su información personal a terceros, excepto:\n\n'
                  '• Cuando sea requerido por ley o autoridad competente\n'
                  '• Con su consentimiento explícito\n'
                  '• Para proteger los derechos y seguridad de GenesApp y sus usuarios',
            ),

            // Derechos del usuario
            _buildSection(
              title: '6. Sus Derechos (Ley 1581 de 2012)',
              content:
                  'Como titular de datos personales, usted tiene derecho a:\n\n'
                  '• Conocer, actualizar y rectificar sus datos personales\n'
                  '• Solicitar prueba de la autorización otorgada\n'
                  '• Ser informado sobre el uso de sus datos\n'
                  '• Presentar quejas ante la Superintendencia de Industria y Comercio\n'
                  '• Revocar la autorización y/o solicitar la supresión de datos\n'
                  '• Acceder de forma gratuita a sus datos personales',
            ),

            // Retención de datos
            _buildSection(
              title: '7. Retención de Datos',
              content:
                  'Conservamos sus datos personales mientras su cuenta esté activa y durante el tiempo necesario para cumplir con obligaciones legales. Puede solicitar la eliminación de su cuenta y datos en cualquier momento desde la configuración de la aplicación.',
            ),

            // Menores de edad
            _buildSection(
              title: '8. Menores de Edad',
              content:
                  'GenesApp está dirigida a profesionales de la salud y usuarios mayores de 18 años. No recopilamos intencionalmente información de menores de edad sin el consentimiento de sus padres o tutores legales.',
            ),

            // Cambios a la política
            _buildSection(
              title: '9. Cambios a esta Política',
              content:
                  'Nos reservamos el derecho de actualizar esta Política de Privacidad. Los cambios significativos serán notificados a través de la aplicación o por correo electrónico. Le recomendamos revisar periódicamente esta política.',
            ),

            // Contacto
            _buildSection(
              title: '10. Contacto',
              content:
                  'Para ejercer sus derechos o realizar consultas sobre esta Política de Privacidad, puede contactarnos:\n\n'
                  'Email: d.alejo.guerrero.e@gmail.com\n'
                  'Responsable: Equipo GenesApp\n'
                  'Institución: Universidad Cooperativa de Colombia\n'
                  'País: Colombia',
            ),

            const SizedBox(height: 32),

            // Footer legal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.verified_user,
                    color: AppColors.accentGreen,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cumplimiento Legal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta política cumple con la Ley 1581 de 2012 '
                    'y el Decreto 1377 de 2013 de Colombia sobre '
                    'protección de datos personales.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
