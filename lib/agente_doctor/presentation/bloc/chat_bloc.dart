import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;

  ChatBloc(this.sendMessage) : super(const ChatState.initial()) {
    on<UserTypedAndSent>(_onSend);
  }

  // --- 🔥 Método nuevo para borrar mensajes
  void clearHistory() {
    emit(const ChatState.initial());
    clear(); // limpia también el almacenamiento persistente
  }

  // --- Detecta tópico por palabras clave ---
  String? _inferTopic(String t) {
    t = t.toLowerCase();
    final williams = RegExp(
      r'\b(williams|síndrome de williams|sindrome de williams)\b',
      unicode: true,
    );
    final mps = RegExp(
      r'\b(mps|mucopoli|mucopolisacaridosis|hurler|hunter|sanfilippo|morquio)\b',
      unicode: true,
    );
    final down = RegExp(r'\b(down|trisom[ií]a\s*21)\b', unicode: true);
    if (williams.hasMatch(t)) return 'williams';
    if (mps.hasMatch(t)) return 'mps';
    if (down.hasMatch(t)) return 'down';
    return null;
  }

  Future<void> _onSend(UserTypedAndSent e, Emitter<ChatState> emit) async {
    final text = e.text.trim();
    if (text.isEmpty) return;
    if (state.isSending) return; // evita doble tap

    final userMsg = ChatMessage(text: text, sender: Sender.user);
    final base = [...state.messages, userMsg];

    final inferred = _inferTopic(text);
    final effectiveTopic = e.topic ?? inferred ?? state.currentTopic;

    emit(
      state.copyWith(
        messages: base,
        isSending: true,
        error: null,
        currentTopic: effectiveTopic,
      ),
    );

    try {
      final botMsg = await sendMessage(
        text,
        topic: effectiveTopic,
        lang: e.lang,
      );

      emit(
        state.copyWith(
          messages: [...base, botMsg],
          isSending: false,
          error: null,
        ),
      );
    } catch (err) {
      emit(state.copyWith(isSending: false, error: err.toString()));
    }
  }

  // -------- Persistencia con hydrated_bloc --------
  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      return ChatState(
        messages:
            (json['messages'] as List<dynamic>? ?? [])
                .map(
                  (e) => ChatMessage(
                    text: e['text'] as String,
                    sender:
                        (e['sender'] as String) == 'user'
                            ? Sender.user
                            : Sender.bot,
                    at:
                        DateTime.tryParse(e['at'] as String? ?? '') ??
                        DateTime.now(),
                    sources:
                        (e['sources'] as List<dynamic>? ?? [])
                            .map((s) => s.toString())
                            .toList(),
                  ),
                )
                .toList(),
        isSending: false,
        error: null,
        currentTopic: json['currentTopic'] as String?,
      );
    } catch (_) {
      return const ChatState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) => {
    'messages':
        state.messages
            .map(
              (m) => {
                'text': m.text,
                'sender': m.sender == Sender.user ? 'user' : 'bot',
                'at': m.at.toIso8601String(),
                'sources': m.sources,
              },
            )
            .toList(),
    'currentTopic': state.currentTopic,
  };
}
