import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_massage.dart';
import '../bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final text = _ctrl.text;
    _ctrl.clear();
    context.read<ChatBloc>().add(UserTypedAndSent(text, topic: null, lang: 'es'));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente IA')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  final msgs = state.messages;
                  return ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: msgs.length + (state.isSending ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == msgs.length && state.isSending) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: _Bubble(
                              text: 'Escribiendo…',
                              sender: Sender.bot,
                              isThinking: true,
                            ),
                          ),
                        );
                      }
                      final m = msgs[i];
                      return Align(
                        alignment:
                            m.sender == Sender.user ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _Bubble(text: m.text, sender: m.sender),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu pregunta…',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _send(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final Sender sender;
  final bool isThinking;

  const _Bubble({required this.text, required this.sender, this.isThinking = false});

  @override
  Widget build(BuildContext context) {
    final isUser = sender == Sender.user;
    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? Colors.blueAccent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: isThinking
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 14, height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Escribiendo…'),
              ],
            )
          : Text(
              text,
              style: TextStyle(color: isUser ? Colors.white : Colors.black87),
            ),
    );
  }
}
