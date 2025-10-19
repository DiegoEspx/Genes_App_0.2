import 'package:dio/dio.dart';
import '../../core/config.dart';
import '../models/chat_models.dart';

class ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSource([Dio? dio])
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: apiBase,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 60),
                sendTimeout: const Duration(seconds: 60),
                headers: {'Content-Type': 'application/json'},
                // (opcional) En algunos entornos conviene no mantener conexión persistente
                // persistentConnection: false, // si tu versión de Dio lo soporta
              ),
            )
          ..interceptors.add(
            LogInterceptor(
              request: true,
              requestBody: true,
              responseBody: true,
              error: true,
            ),
          );

  /// “Despierta” el backend (especialmente útil en Railway) llamando a /health.
  /// Ignora cualquier error: solo es un ping.
  Future<void> warmup() async {
    try {
      await _dio.get(
        '/health',
        options: Options(
          sendTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
        ),
      );
    } catch (_) {
      // ignoramos a propósito
    }
  }

  Future<ChatResponseModel> send(ChatRequestModel req) async {
    try {
      final resp = await _dio.post('/chat', data: req.toJson());
      return ChatResponseModel.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final t = e.type;
      if (t == DioExceptionType.connectionTimeout ||
          t == DioExceptionType.receiveTimeout ||
          t == DioExceptionType.sendTimeout) {
        throw Exception(
          'Tiempo de espera agotado. El backend tardó demasiado en responder.',
        );
      }
      final msg = e.response?.data is Map
          ? (e.response?.data['detail']?.toString() ?? e.message)
          : e.message;
      throw Exception('Error de red: $msg');
    }
  }
}
