// lib/widgets/institutional_email_validator.dart

class InstitutionalEmailValidator {
  static bool isInstitutional(String email) {
    return email.trim().toLowerCase().endsWith('@gmail.com');
    //'@campusucc.edu.co'
  }

  static String? validate(String email) {
    if (email.trim().isEmpty) {
      return 'El correo no puede estar vacío';
    }
    if (!isInstitutional(email)) {
      return 'Solo se permite registro con correos @ucc.edu.co';
    }
    return null;
  }
}
