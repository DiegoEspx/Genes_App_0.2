import 'package:flutter/foundation.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_models.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Future<ChatMessage> send(
    String message, {
    String? topic,
    String? lang,
  }) async {
    final req = ChatRequestModel(message: message, topic: topic, lang: lang);

    final res = await remote.send(req);

    // 🔍 DEBUG: Log para verificar que las citas llegan
    if (kDebugMode) {
      print('📚 [ChatRepo] Reply recibido: ${res.reply.substring(0, 50)}...');
      print(
        '📚 [ChatRepo] Citations APA recibidas: ${res.citationsApa.length}',
      );
      if (res.citationsApa.isNotEmpty) {
        print('📚 [ChatRepo] Primera cita: ${res.citationsApa.first}');
      }
    }

    return ChatMessage.bot(
      text: res.reply,
      sources: res.citationsApa.isNotEmpty ? res.citationsApa : null,
    );
  }
}
