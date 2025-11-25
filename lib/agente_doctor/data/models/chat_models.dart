import 'package:flutter/foundation.dart';

class ChatRequestModel {
  final String message;
  final String? context;
  final String? topic;
  final int? minYear;
  final List<String>? types;
  final String? lang;

  ChatRequestModel({
    required this.message,
    this.context,
    this.topic,
    this.minYear,
    this.types,
    this.lang,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    if (context != null) 'context': context,
    if (topic != null) 'topic': topic,
    if (minYear != null) 'min_year': minYear,
    if (types != null) 'types': types,
    if (lang != null) 'lang': lang,
  };
}

class ChatResponseModel {
  final String reply;
  final List<String> citationsApa;

  ChatResponseModel({required this.reply, List<String>? citationsApa})
    : citationsApa = citationsApa ?? [];

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    // 🔍 DEBUG: Log del JSON crudo
    if (kDebugMode) {
      print('📦 [ChatModel] JSON recibido: ${json.keys}');
      print('📦 [ChatModel] citations_apa raw: ${json['citations_apa']}');
    }

    final reply = (json['reply'] ?? '').toString();

    // Parseo robusto de citations_apa
    List<String> citations = [];
    final rawCitations = json['citations_apa'];

    if (rawCitations is List) {
      citations =
          rawCitations
              .where((e) => e != null)
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
    }

    // 🔍 DEBUG: Log del resultado
    if (kDebugMode) {
      print('📦 [ChatModel] Citations parseadas: ${citations.length}');
      if (citations.isNotEmpty) {
        print('📦 [ChatModel] Primera citation: ${citations.first}');
      }
    }

    return ChatResponseModel(reply: reply, citationsApa: citations);
  }

  @override
  String toString() =>
      'ChatResponseModel(reply: ${reply.length} chars, citations: ${citationsApa.length})';
}
