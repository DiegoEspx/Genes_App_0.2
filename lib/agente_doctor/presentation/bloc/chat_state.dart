part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isSending;
  final String? error;
  final String? currentTopic;

  const ChatState({
    required this.messages,
    required this.isSending,
    required this.error,
    this.currentTopic,
  });

  const ChatState.initial()
      : messages = const [],
        isSending = false,
        error = null,
        currentTopic = null;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? error,
    String? currentTopic,
  }) => ChatState(
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
        error: error,
        currentTopic: currentTopic ?? this.currentTopic,
      );

  @override
  List<Object?> get props => [messages, isSending, error, currentTopic];
}
