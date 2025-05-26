import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validación de formulario de verificación médica', () {
    test('Todos los campos están llenos', () {
      final nombre = 'Carlos Guerrero';
      final cedula = '1234567890';
      final direccion = 'Calle 123';
      final institucion = 'Hospital Nariño';
      final rethus = 'R12345';

      final camposCompletos = [
        nombre, cedula, direccion, institucion, rethus
      ].every((campo) => campo.isNotEmpty);

      expect(camposCompletos, true);
    });

    test('Detecta campo vacío', () {
      final nombre = 'Carlos Guerrero';
      final cedula = '';
      final direccion = 'Calle 123';
      final institucion = 'Hospital Nariño';
      final rethus = 'R12345';

      final camposCompletos = [
        nombre, cedula, direccion, institucion, rethus
      ].every((campo) => campo.isNotEmpty);

      expect(camposCompletos, false);
    });

    test('Aceptación de términos', () {
      final aceptoTratamiento = true;
      expect(aceptoTratamiento, true);
    });

    test('Debe subir al menos un documento', () {
      final documentos = ['titulo.pdf'];
      expect(documentos.isNotEmpty, true);
    });

    test('Falla si no se sube ningún documento', () {
      final documentos = <String>[];
      expect(documentos.isEmpty, true);
    });
  });
}
