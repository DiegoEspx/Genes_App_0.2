import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repo;
  SendMessage(this.repo);
  
  Future<ChatMessage> call(String message, {String? topic, String? lang}) {
    return repo.send(message, topic: topic, lang: lang);
  }
}
