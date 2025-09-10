import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_massage.dart';
import '../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;

  ChatBloc(this.sendMessage) : super(const ChatState.initial()) {
    on<UserTypedAndSent>(_onSend);
  }

  Future<void> _onSend(UserTypedAndSent e, Emitter<ChatState> emit) async {
    if (e.text.trim().isEmpty) return;

    // pinta mensaje del usuario
    final userMsg = ChatMessage(text: e.text.trim(), sender: Sender.user);
    emit(state.copyWith(
      messages: [...state.messages, userMsg],
      isSending: true,
      error: null,
    ));

    try {
      final botMsg = await sendMessage(e.text.trim(), topic: e.topic, lang: e.lang);
      emit(state.copyWith(
        messages: [...state.messages, userMsg, botMsg],
        isSending: false,
        error: null,
      ));
    } catch (err) {
      emit(state.copyWith(
        isSending: false,
        error: 'No se pudo contactar a la IA. Verifica la URL: $err',
      ));
    }
  }
}
