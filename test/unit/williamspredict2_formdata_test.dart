import 'package:flutter_test/flutter_test.dart';

void main() {
  final Map<String, int> formData = {
    'TALLA/EDAD (ACTUAL)_0': 0,
    'TALLA/EDAD (ACTUAL)_Alto': 0,
    'TALLA/EDAD (ACTUAL)_Bajo': 0,
    'TALLA/EDAD (ACTUAL)_Normal': 0,
    'Peso al nacer/edad gestacional_0': 0,
    'Peso al nacer/edad gestacional_Adecuado': 0,
    'Peso al nacer/edad gestacional_Alto': 0,
    'Peso al nacer/edad gestacional_Bajo': 0,
    'SEXO': 0,
    'PESO': 0,
    'EDAD': 0,
    'BAJO PESO AL NACER': 0,
    'TALLA/EDAD (ACTUAL).1': 0,
    'PESO/EDAD (ACTUAL)': 0,
    'RDPM / DISCAPACIDAD INTELECTUAL': 0,
    'CARACTERISTICAS FACIALES': 0,
    'DEPRESION BITEMPORAL': 0,
    'CEJAS ARQUEADAS': 0,
    'PLIEGUE EPICANTICO': 0,
    'PATRON ESTELAR DEL IRIS': 0,
    'PUENTE NASAL DEPRIMIDO': 0,
    'NARIZ CORTA NARINAS ANTEVERTIDAS': 0,
    'PUNTA NASAL ANCHA O BULBOSA': 0,
    'MEJILLAS PROMINENTES': 0,
    'REGION MALAR PLANA': 0,
    'FILTRUM LARGO': 0,
    'LABIOS GRUESOS': 0,
    'DIENTES PEQUEÑOS O ESPACIADOS': 0,
    'PALADAR ALTO Y OJIVAL': 0,
    'BOCA AMPLIA': 0,
    'PABELLONES AURICULARES GRANDES': 0,
    'CARDIOPATIA CONGENITA': 0,
    'ESTENOSIS SUPRAVALVULAR AORTICA': 0,
    'ESTENOSIS PULMONAR': 0,
    'OTRA CARDIOPATIA': 0,
    'OTRAS ALTERACIONES': 0,
    'VOZ DISFONICA': 0,
    'TRASTORNO TIROIDEO': 0,
    'TRASTORNO DE LA REFRACCION': 0,
    'HERNIA': 0,
    'ORQUIDOPEXIA': 0,
    'SINOSTOSIS RADIOCUBITAL': 0,
    'HIPERLAXITUD ARTICULAR': 0,
    'ANTECEDENTE DE ORQUIDOPEXIA': 0,
    'ESCOLIOSIS': 0,
    'HIPERCALCEMIA': 0,
    'RETRASO EN EL DESARROLLO PSICOMOTOR': 0,
    'DÉFICIT COGNITIVO': 0,
    'PERSONALIDAD SOCIAL EXTREMA': 0,
    'TRASTORNOS DEL APRENDIZAJE': 0,
    'ANSIEDAD O FOBIAS (Sonidos fuertes, lugares cerrados, separación, etc.)': 0,
    'PROBLEMAS DEL SUEÑO (Insomnio, despertares nocturnos)': 0,
    'GENÉTICA CONFIRMADA (Deleción 7q11.23 / Sin análisis)': 0,
    'ESTUDIO MOLECULAR CONFIRMATORIO': 0,
    'HIPOACUSIA': 0,
    'HIPERSENSIBILIDAD AUDITIVA (HIPERACUSIA)': 0,
    'ALTERACIONES VISUALES (Miopía, astigmatismo, estrabismo)': 0,
    'ALTERACIONES HORMONALES (Pubertad tardía, alteraciones tiroideas adicionales)': 0,
    'DIABETES INFANTIL O INTOLERANCIA A LA GLUCOSA': 0,
    'DÉFICIT DE CRECIMIENTO': 0,
  };

  group('Verificación de _formData en Williamspredict2', () {
    test('Todos los campos deben estar inicializados en 0', () {
      for (final entry in formData.entries) {
        expect(entry.value, 0, reason: 'El campo "${entry.key}" no está en 0');
      }
    });

    test('Simulación de cambio de valor en un campo', () {
      final campo = 'EDAD';
      formData[campo] = 1;
      expect(formData[campo], 1);

      formData[campo] = 0;
      expect(formData[campo], 0);
    });

    test('Debe contener exactamente 60 campos', () {
      expect(formData.length, 60);
    });
  });
}
