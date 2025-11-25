import 'package:equatable/equatable.dart';

enum Sender { user, bot }

class ChatMessage extends Equatable {
  final String text;
  final Sender sender;
  final DateTime at;
  final List<String> sources;

  ChatMessage({
    required this.text,
    required this.sender,
    DateTime? at,
    List<String>? sources, // ← Cambiado a nullable
  }) : at = at ?? DateTime.now(),
       sources = sources ?? []; // ← Crea nueva lista vacía si es null

  // Constructor específico para mensajes del bot con fuentes
  ChatMessage.bot({required this.text, List<String>? sources, DateTime? at})
    : sender = Sender.bot,
      at = at ?? DateTime.now(),
      sources = sources ?? [];

  // Constructor específico para mensajes del usuario
  ChatMessage.user({required this.text, DateTime? at})
    : sender = Sender.user,
      at = at ?? DateTime.now(),
      sources = [];

  @override
  List<Object?> get props => [text, sender, at, sources];

  @override
  String toString() =>
      'ChatMessage(sender: $sender, text: ${text.length} chars, sources: ${sources.length})';
}
