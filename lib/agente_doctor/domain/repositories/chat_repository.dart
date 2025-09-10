import '../entities/chat_massage.dart';

abstract class ChatRepository {
  /// Envía el mensaje del usuario y devuelve la respuesta del bot.
  Future<ChatMessage> send(String message,
      {String? topic, String? lang});
}
