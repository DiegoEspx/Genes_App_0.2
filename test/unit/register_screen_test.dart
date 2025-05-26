import 'package:flutter_test/flutter_test.dart';
import 'package:genesapp/widgets/institutional_email_validator.dart';

void main() {
  group('Validaciones de registro de usuario', () {
    test('Las contraseñas coinciden', () {
      final pass1 = '123456';
      final pass2 = '123456';
      expect(pass1 == pass2, true);
    });

    test('Las contraseñas no coinciden', () {
      final pass1 = '123456';
      final pass2 = '654321';
      expect(pass1 == pass2, false);
    });

    test('Correo institucional válido', () {
      final email = 'medico@campusucc.edu.co';
      expect(InstitutionalEmailValidator.validate(email), null);
    });

    test('Correo con dominio incorrecto', () {
      final email = 'medico@gmail.com';
      expect(
        InstitutionalEmailValidator.validate(email),
        'Solo se permite registro con correos @ucc.edu.co',
      );
    });

    test('Correo vacío', () {
      final email = '';
      expect(
        InstitutionalEmailValidator.validate(email),
        'El correo no puede estar vacío',
      );
    });
  });
}
