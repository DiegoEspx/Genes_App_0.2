import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './predict_data.dart';

import '../../widgets/custom_app_bar_simple.dart';
import '../widgets/question_card.dart';
import '../widgets/williamsResultadoScreen.dart';

class Williamspredict extends StatefulWidget {
  const Williamspredict({super.key});

  @override
  State<Williamspredict> createState() => _WilliamspredictState();
}

class _WilliamspredictState extends State<Williamspredict> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, int> _formData = Map.from(initialFormData);
  late final List<Map<String, String>> _campos;
  late final Map<String, String> _infoTexts;

  int _currentCardIndex = 0;
  final List<GlobalKey> _keys = List.generate(100, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _campos = campos.where((campo) => !_clavesOcultas.contains(campo['key'])).toList();
    _infoTexts = infoTexts;
  }


  void _setAnswer(String key, int value) {
    setState(() {
      _formData[key] = value;
      if (_currentCardIndex < _campos.length - 1) {
        _currentCardIndex++;
        _scrollToNextQuestion();
      }
    });
  }

  void _scrollToNextQuestion() {
    final context = _keys[_currentCardIndex].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  Future<void> _enviarFormulario() async {
    const url = 'http://10.162.248.191:5000/predict';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_formData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String resultado = data['diagnostico'];
        final double probabilidad = data['probabilidad'];

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WilliamsResultadoScreen(
              resultado: resultado,
              probabilidad: probabilidad,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error en la predicción")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    }
  }
    final List<String> _clavesOcultas = [
    'TALLA/EDAD (ACTUAL)_0',
    'TALLA/EDAD (ACTUAL)_Alto',
    'TALLA/EDAD (ACTUAL)_Bajo',
    'TALLA/EDAD (ACTUAL)_Normal',
    'Peso al nacer/edad gestacional_0',
    'Peso al nacer/edad gestacional_Adecuado',
    'Peso al nacer/edad gestacional_Alto',
    'Peso al nacer/edad gestacional_Bajo',
    'SEXO',
    'PESO',
    'EDAD',
    'BAJO PESO AL NACER',
    'TALLA/EDAD (ACTUAL).1',
    'PESO/EDAD (ACTUAL)',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: "Predictividad Williams",
        color: Colors.blue,
      ),
      body: SafeArea(
        child: _campos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    for (int index = 0; index < _campos.length; index++)
                      QuestionCard(
                        keyWidget: _keys[index],
                        campo: _campos[index],
                        valorActual: _formData[_campos[index]['key']] ?? 0,
                        index: index,
                        isActive: index == _currentCardIndex,
                        infoText: _infoTexts[_campos[index]['key']] ?? '',
                        onAnswer: _setAnswer,
                      ),
                    ElevatedButton(
                      onPressed: _enviarFormulario,
                      child: const Text("Enviar Predicción"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
