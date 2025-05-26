import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:genesapp/usersScreen/pdf_visualizador_screen.dart';
import 'package:genesapp/widgets/app_colors.dart';

class AdminVerificacionPendiente extends StatefulWidget {
  const AdminVerificacionPendiente({super.key});

  @override
  State<AdminVerificacionPendiente> createState() =>
      _AdminVerificacionPanelState();
}

class _AdminVerificacionPanelState extends State<AdminVerificacionPendiente> {
  final String baseUrl = 'http://10.162.67.105:5001';
  //'https://genesapp.centralus.cloudapp.azure.com/api1';
  List<Map<String, dynamic>> solicitudes = [];
  bool isLoading = false;

  Future<void> cargarSolicitudes() async {
    setState(() => isLoading = true);
    final res = await http.get(Uri.parse('$baseUrl/verificacion/solicitudes'));

    if (res.statusCode == 200) {
      final cedulas = List<String>.from(json.decode(res.body));
      List<Map<String, dynamic>> temp = [];

      for (String cedula in cedulas) {
        final datosRes = await http.get(
          Uri.parse('$baseUrl/verificacion/datos/$cedula'),
        );
        if (datosRes.statusCode == 200) {
          final datos = json.decode(datosRes.body);

          // Obtener el rol actual desde Firestore
          final userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(datos['id_per'])
                  .get();
          final userRole = userDoc.data()?['role'] ?? 'sin rol';
          datos['rol_actual'] = userRole;

          temp.add(datos);
        }
      }

      temp.sort(
        (a, b) => DateTime.parse(
          b['fecha_envio'],
        ).compareTo(DateTime.parse(a['fecha_envio'])),
      );

      setState(() {
        solicitudes = temp;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> cambiarRol(String uid, String nuevoRol) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(color: AppColors.primaryBlue),
                SizedBox(width: 20),
                Text("Procesando cambio..."),
              ],
            ),
          ),
    );

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'role': nuevoRol,
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.accentGreen,
          content: Text('✅ Rol cambiado a $nuevoRol'),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('❌ Error al cambiar rol: $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    cargarSolicitudes();
  }

  Widget _buildDocumentoVisual(String url) {
    final fullUrl = "http://10.162.67.105:5001$url";
    //'https://genesapp.centralus.cloudapp.azure.com$url';
    final uri = Uri.parse(fullUrl);
    final fileName = url.split('/').last.toLowerCase();

    final isImage =
        fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png');
    final isPdf = fileName.endsWith('.pdf');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isImage
            ? Icons.image
            : isPdf
            ? Icons.picture_as_pdf
            : Icons.description,
        color:
            isImage
                ? AppColors.accentGreen
                : isPdf
                ? AppColors.primaryBlue
                : AppColors.triadicPurple,
      ),
      title: Text(
        fileName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      onTap: () async {
        if (isImage) {
          showDialog(
            context: context,
            builder:
                (_) => Dialog(
                  child: InteractiveViewer(
                    child: Image.network(fullUrl, fit: BoxFit.contain),
                  ),
                ),
          );
        } else if (isPdf) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PdfViewerScreen(url: fullUrl)),
          );
        } else if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No se pudo abrir el documento. Intenta con una app compatible o súbelo como PDF.',
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: 'Panel de Verificación Médica',
        color: AppColors.primaryBlue,
      ),
      backgroundColor: const Color(0xFFF6FFF9),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: solicitudes.length,
                  itemBuilder: (context, index) {
                    final data = solicitudes[index];
                    final uid = data['id_per'];
                    final fecha = DateFormat(
                      'dd/MM/yyyy - HH:mm',
                    ).format(DateTime.parse(data['fecha_envio']));

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primaryBlue,
                                child: Text(
                                  data['nombre']
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['nombre'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    data['email'] ?? '',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rol actual: ${data['rol_actual']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    fecha,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        solicitudes.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.redAccent.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          Text("🆔 Cédula: ${data['cedula']}"),
                          Text("🏠 Dirección: ${data['direccion']}"),
                          Text("🏥 Institución: ${data['institucion']}"),
                          Text("🔢 ReTHUS: ${data['rethus']}"),
                          const SizedBox(height: 10),
                          const Text(
                            "📎 Documentos adjuntos:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ...List<String>.from(data['documentos']).map(
                            (url) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: _buildDocumentoVisual(url),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "🛠 Cambiar rol:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => cambiarRol(uid, 'patient'),
                                  icon: const Icon(Icons.person),
                                  label: const Text('Paciente'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => cambiarRol(uid, 'doctor'),
                                  icon: const Icon(Icons.medical_services),
                                  label: const Text('Médico'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accentGreen,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
