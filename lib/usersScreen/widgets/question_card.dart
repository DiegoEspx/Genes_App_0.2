import 'package:flutter/material.dart';
import '../widgets/question_info.dart';

class QuestionCard extends StatelessWidget {
  final GlobalKey keyWidget;
  final Map<String, String> campo;
  final int valorActual;
  final int index;
  final bool isActive;
  final String infoText;
  final Function(String, int) onAnswer;

  const QuestionCard({
    super.key,
    required this.keyWidget,
    required this.campo,
    required this.valorActual,
    required this.index,
    required this.isActive,
    required this.infoText,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    String respuesta =
        valorActual == 1 ? 'Sí' : (valorActual == 0 ? 'No' : '');

    return AnimatedContainer(
      key: keyWidget,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      constraints: BoxConstraints(minHeight: isActive ? 140 : 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isActive ? Colors.blueAccent : Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // importante para evitar overflow
          children: [
            Text(
              campo['label']!,
              style: TextStyle(
                fontSize: 20,
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 10),
              QuestionInfo(infoText: infoText),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "yesBtn$index",
                    onPressed: () => onAnswer(campo['key']!, 1),
                    child: const Icon(Icons.check),
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(width: 30),
                  FloatingActionButton(
                    heroTag: "noBtn$index",
                    onPressed: () => onAnswer(campo['key']!, 0),
                    child: const Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ],
            if (!isActive && respuesta.isNotEmpty) ...[
              const SizedBox(height: 15),
              Text(
                'Respuesta: $respuesta',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
