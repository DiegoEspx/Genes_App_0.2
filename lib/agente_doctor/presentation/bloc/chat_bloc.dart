import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;

  ChatBloc(this.sendMessage) : super(const ChatState.initial()) {
    on<UserTypedAndSent>(_onSend);
  }

  // --- Detecta tópico por palabras clave ---
  String? _inferTopic(String t) {
    t = t.toLowerCase();
    final williams = RegExp(r'\b(williams|síndrome de williams|sindrome de williams)\b', unicode: true);
    final mps      = RegExp(r'\b(mps|mucopoli|mucopolisacaridosis|hurler|hunter|sanfilippo|morquio)\b', unicode: true);
    final down     = RegExp(r'\b(down|trisom[ií]a\s*21)\b', unicode: true);
    if (williams.hasMatch(t)) return 'williams';
    if (mps.hasMatch(t)) return 'mps';
    if (down.hasMatch(t)) return 'down';
    return null;
  }

  Future<void> _onSend(UserTypedAndSent e, Emitter<ChatState> emit) async {
    final text = e.text.trim();
    if (text.isEmpty) return;
    if (state.isSending) return; // evita doble tap

    // 1) Mensaje del usuario (una sola vez)
    final userMsg = ChatMessage(text: text, sender: Sender.user);
    final base = [...state.messages, userMsg];

    // 2) Determinar topic efectivo (prioridad: explicit -> inferido -> último)
    final inferred = _inferTopic(text);
    final effectiveTopic = e.topic ?? inferred ?? state.currentTopic;

    // 3) Mostrar "escribiendo…" y guardar el topic actual
    emit(state.copyWith(
      messages: base,
      isSending: true,
      error: null,
      currentTopic: effectiveTopic,
    ));

    try {
      // 4) Llamar al backend con el topic efectivo
      final botMsg = await sendMessage(text, topic: effectiveTopic, lang: e.lang);

      // 5) Agregar SOLO la respuesta del bot
      emit(state.copyWith(
        messages: [...base, botMsg],
        isSending: false,
        error: null,
      ));
    } catch (err) {
      emit(state.copyWith(isSending: false, error: err.toString()));
    }
  }
}
