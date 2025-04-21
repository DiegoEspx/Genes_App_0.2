import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:genesapp/usersScreen/pdf_visualizador_screen.dart';
import 'package:genesapp/usersScreen/perfilview.dart';
import 'package:genesapp/widgets/app_colors.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';

class VerArticulosScreen extends StatefulWidget {
  const VerArticulosScreen({super.key});

  @override
  State<VerArticulosScreen> createState() => _VerArticulosScreenState();
}

class _VerArticulosScreenState extends State<VerArticulosScreen> {
  File? _archivo;
  bool _isUploading = false;

  Future<void> _seleccionarYSubirArchivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _archivo = File(result.files.single.path!);
        _isUploading = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uri = Uri.parse(
        'https://genesapp.centralus.cloudapp.azure.com/api2/upload',
      );

      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('file', _archivo!.path),
      );
      request.fields['uid'] = user.uid;
      request.fields['email'] = user.email ?? '';

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final nombreArchivo = data['archivo'];

          await FirebaseFirestore.instance.collection('articulos_medicos').add({
            'nombreArchivo': nombreArchivo,
            'uid': user.uid,
            'email': user.email,
            'fecha': Timestamp.now(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Archivo subido correctamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Error al subir archivo: $responseBody')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Error de conexión: $e')));
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  String _formatearFecha(Timestamp timestamp) {
    final fecha = timestamp.toDate();
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: "Artículos Publicados",
        color: Colors.blueAccent,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('articulos_medicos')
                  .orderBy('fecha', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No hay artículos publicados."));
            }

            final articulos = snapshot.data!.docs;

            return ListView.builder(
              itemCount: articulos.length,
              itemBuilder: (context, index) {
                final data = articulos[index].data() as Map<String, dynamic>;
                final nombre = data['nombreArchivo'] ?? 'Sin nombre';
                final url =
                    'https://genesapp.centralus.cloudapp.azure.com/api2/upload/$nombre';
                final email = data['email'] ?? 'Desconocido';
                final fecha =
                    data['fecha'] != null
                        ? _formatearFecha(data['fecha'])
                        : 'Sin fecha';
                final fotoPerfil = data['fotoPerfil'] ?? '';
                final uid = data['uid'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => PerfilUsuarioScreen(uid: uid),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    fotoPerfil.isNotEmpty
                                        ? NetworkImage(fotoPerfil)
                                        : const AssetImage(
                                              "assets/images/default_user.png",
                                            )
                                            as ImageProvider,
                                radius: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  fecha,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PdfViewerScreen(url: url),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Ver artículo',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isUploading ? null : _seleccionarYSubirArchivo,
        backgroundColor: AppColors.accentGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Hace el botón más redondo
        ),
        child:
            _isUploading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }
}
