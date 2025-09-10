part of 'chat_bloc.dart';

class UserTypedAndSent extends ChatEvent {
  final String text;
  final String? topic;
  final String? lang;

  UserTypedAndSent(this.text, {this.topic, this.lang});

  @override
  List<Object?> get props => [text, topic, lang];
}

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}
