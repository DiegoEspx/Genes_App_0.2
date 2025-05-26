import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validación de campos de LoginScreen', () {
    test('Email y contraseña válidos', () {
      final email = 'usuario@genesapp.com';
      final password = '123456';

      final camposCompletos = email.isNotEmpty && password.isNotEmpty;
      expect(camposCompletos, true);
    });

    test('Email vacío', () {
      final email = '';
      final password = '123456';

      final camposCompletos = email.isNotEmpty && password.isNotEmpty;
      expect(camposCompletos, false);
    });

    test('Contraseña vacía', () {
      final email = 'usuario@genesapp.com';
      final password = '';

      final camposCompletos = email.isNotEmpty && password.isNotEmpty;
      expect(camposCompletos, false);
    });

    test('Formato de email válido', () {
      final email = 'user@example.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      expect(emailRegex.hasMatch(email), true);
    });

    test('Formato de email inválido', () {
      final email = 'userexample.com';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      expect(emailRegex.hasMatch(email), false);
    });
  });
}
