import 'package:equatable/equatable.dart';

enum Sender { user, bot }

class ChatMessage extends Equatable {
  final String text;
  final Sender sender;
  final DateTime at;

  // ← sin 'const'
  ChatMessage({
    required this.text,
    required this.sender,
    DateTime? at,
  }) : at = at ?? DateTime.now();

  @override
  List<Object?> get props => [text, sender, at];
}
