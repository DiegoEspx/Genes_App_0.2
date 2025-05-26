// lib/widgets/question_info.dart

import 'package:flutter/material.dart';

class QuestionInfo extends StatelessWidget {
  final String infoText;

  const QuestionInfo({Key? key, required this.infoText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        infoText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
