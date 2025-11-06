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
    this.sources = const [],   
    
  }) : at = at ?? DateTime.now();

  @override
  List<Object?> get props => [text, sender, at, sources]; 
  
}
