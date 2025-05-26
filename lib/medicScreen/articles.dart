import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class SubirArticuloScreen extends StatefulWidget {
  const SubirArticuloScreen({super.key});

  @override
  State<SubirArticuloScreen> createState() => _SubirArticuloScreenState();
}

class _SubirArticuloScreenState extends State<SubirArticuloScreen> {
  File? _archivo;
  bool _isUploading = false;
  String? _mensaje;

  Future<void> _seleccionarArchivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _archivo = File(result.files.single.path!));
    }
  }

  Future<void> _subirArchivo() async {
    if (_archivo == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isUploading = true;
      _mensaje = null;
    });

    final uri = Uri.parse('http://192.168.20.30:5000/api2/upload');

    try {
      print('🟡 Archivo seleccionado: ${_archivo!.path}');
      print('🟡 Enviando archivo a: $uri');
      print('🟡 Usuario: ${user.uid} - ${user.email}');

      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('file', _archivo!.path),
      );
      request.fields['uid'] = user.uid;
      request.fields['email'] = user.email ?? '';

      final response = await request.send();
      print('📨 Código de respuesta: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      print('📨 Cuerpo de respuesta: $responseBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final nombreArchivo = data['archivo'];

        await FirebaseFirestore.instance.collection('articulos_medicos').add({
          'nombreArchivo': nombreArchivo,
          'uid': user.uid,
          'email': user.email,
          'fecha': Timestamp.now(),
        });

        setState(() => _mensaje = '✅ Archivo subido correctamente');
      } else {
        setState(
          () => _mensaje = '❌ Error ${response.statusCode}: $responseBody',
        );
      }
    } catch (e) {
      print('❌ Error en la subida: $e');
      setState(() => _mensaje = '❌ Error de conexión: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicar artículo PDF')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _seleccionarArchivo,
              icon: const Icon(Icons.upload_file),
              label: const Text("Seleccionar archivo PDF"),
            ),
            if (_archivo != null) ...[
              const SizedBox(height: 10),
              Text("Archivo seleccionado: ${path.basename(_archivo!.path)}"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isUploading ? null : _subirArchivo,
                child:
                    _isUploading
                        ? const CircularProgressIndicator()
                        : const Text("Subir Artículo"),
              ),
            ],
            if (_mensaje != null) ...[
              const SizedBox(height: 20),
              Text(_mensaje!, style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
