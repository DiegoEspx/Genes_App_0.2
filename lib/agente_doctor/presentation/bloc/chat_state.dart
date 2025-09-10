part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isSending;
  final String? error;

  const ChatState({
    required this.messages,
    required this.isSending,
    required this.error,
  });

  const ChatState.initial()
      : messages = const [],
        isSending = false,
        error = null;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? error,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
        error: error,
      );

  @override
  List<Object?> get props => [messages, isSending, error];
}
