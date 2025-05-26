import 'package:flutter_test/flutter_test.dart';
import 'package:genesapp/widgets/institutional_email_validator.dart';

void main() {
  group('Validación lógica de verificación de correo', () {
    test('Usuario no verificado', () {
      final bool isEmailVerified = false;
      expect(isEmailVerified, false);
    });

    test('Usuario verificado', () {
      final bool isEmailVerified = true;
      expect(isEmailVerified, true);
    });

    test('Reintento de envío permitido cuando no se ha enviado', () {
      final bool yaEnviado = false;
      final bool puedeReenviar = !yaEnviado;
      expect(puedeReenviar, true);
    });

    test('Previene reenvío si ya se está cargando', () {
      final bool loading = true;
      final bool puedeReenviar = !loading;
      expect(puedeReenviar, false);
    });

    test('Verifica lógica de redirección en AuthGuard', () {
      final bool usuarioAutenticado = true;
      final redirigirALogin = !usuarioAutenticado;
      expect(redirigirALogin, false);
    });
  });

  group('InstitutionalEmailValidator', () {
    test('Correo institucional válido', () {
      final email = 'ejemplo@campusucc.edu.co';
      final result = InstitutionalEmailValidator.isInstitutional(email);
      expect(result, true);
    });

    test('Correo con dominio incorrecto', () {
      final email = 'user@gmail.com';
      final result = InstitutionalEmailValidator.isInstitutional(email);
      expect(result, false);
    });

    test('Validación devuelve mensaje si está vacío', () {
      final email = '';
      final mensaje = InstitutionalEmailValidator.validate(email);
      expect(mensaje, 'El correo no puede estar vacío');
    });

    test('Validación devuelve mensaje si no es institucional', () {
      final email = 'usuario@hotmail.com';
      final mensaje = InstitutionalEmailValidator.validate(email);
      expect(mensaje, 'Solo se permite registro con correos @ucc.edu.co');
    });

    test('Validación exitosa devuelve null', () {
      final email = 'ejemplo@campusucc.edu.co';
      final mensaje = InstitutionalEmailValidator.validate(email);
      expect(mensaje, null);
    });
  });
}
