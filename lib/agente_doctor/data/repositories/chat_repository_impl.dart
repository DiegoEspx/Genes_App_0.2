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
    return ChatMessage(
      text: res.reply,
      sender: Sender.bot,
      sources: res.citationsApa, // 👈 pasa las APA
    );
  }
}
