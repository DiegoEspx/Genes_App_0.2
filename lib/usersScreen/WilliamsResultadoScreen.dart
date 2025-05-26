import 'dart:async';
import 'package:flutter/material.dart';

class WilliamsResultadoScreen extends StatefulWidget {
  final String resultado;
  final double probabilidad;

  const WilliamsResultadoScreen({
    super.key,
    required this.resultado,
    required this.probabilidad,
  });

  @override
  State<WilliamsResultadoScreen> createState() => _WilliamsResultadoScreenState();
}

class _WilliamsResultadoScreenState extends State<WilliamsResultadoScreen> {
  bool _mostrarResultado = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _mostrarResultado = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultado de Predicción")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _mostrarResultado
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Diagnóstico: ${widget.resultado}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("Probabilidad: ${(widget.probabilidad * 100).toStringAsFixed(2)}%",
                        style: const TextStyle(fontSize: 18, color: Colors.blueAccent)),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Volver"),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Prediciendo...", style: TextStyle(fontSize: 18)),
                  ],
                ),
        ),
      ),
    );
  }
}
