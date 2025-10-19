import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importa tus capas del chat (ajusta paths si tu estructura difiere)
import 'package:genesapp/agente_doctor/presentation/pages/chat_page.dart';
import 'package:genesapp/agente_doctor/presentation/bloc/chat_bloc.dart';
import 'package:genesapp/agente_doctor/data/datasources/chat_remote_data_source.dart';
import 'package:genesapp/agente_doctor/data/repositories/chat_repository_impl.dart';
import 'package:genesapp/agente_doctor/domain/usecases/send_message.dart';

/// Botón flotante (FAB) para abrir el chat IA.
/// Úsalo como: floatingActionButton: const ChatFab()
class ChatFab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool extended; // true = FAB con texto, false = solo ícono
  final Object? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ChatFab({
    super.key,
    this.label = 'Chat IA',
    this.icon = Icons.chat_bubble_outline,
    this.extended = true,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
  });

  Future<void> _openChat(BuildContext context) async {
    // Datasource con configuración de red y warm-up
    final ds = ChatRemoteDataSource();
    await ds.warmup(); // 👈 ping a /health para “despertar” el backend

    final repo = ChatRepositoryImpl(ds);
    final usecase = SendMessage(repo);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ChatBloc(usecase),
          child: const ChatPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final fg = foregroundColor ?? Theme.of(context).colorScheme.onPrimary;

    if (extended) {
      return FloatingActionButton.extended(
        heroTag: heroTag,
        onPressed: () => _openChat(context),
        icon: Icon(icon),
        label: Text(label),
        backgroundColor: bg,
        foregroundColor: fg,
      );
    }
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: () => _openChat(context),
      backgroundColor: bg,
      foregroundColor: fg,
      child: Icon(icon),
    );
  }
}

/// Botón normal (no flotante) para colocar en cualquier parte de la UI.
/// Úsalo en filas/columnas: ChatButton()
class ChatButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final ButtonStyle? style;

  const ChatButton({
    super.key,
    this.label = 'Chat IA',
    this.icon = Icons.chat_bubble_outline,
    this.style,
  });

  Future<void> _open(BuildContext context) async {
    final ds = ChatRemoteDataSource();
    await ds.warmup(); // 👈 igual que en el FAB

    final repo = ChatRepositoryImpl(ds);
    final usecase = SendMessage(repo);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ChatBloc(usecase),
          child: const ChatPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => _open(context),
      icon: Icon(icon),
      label: Text(label),
      style: style,
    );
  }
}
