import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genesapp/pacientScreen/verificacion_medico_screen.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';
import 'package:genesapp/widgets/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get();
        if (doc.exists) {
          setState(() {
            userData = doc.data();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        error = 'Error al cargar datos';
        isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    final TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER COLORIDO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.accentGreen, AppColors.primaryBlue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.lock_reset, size: 40, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        "Cambiar Contraseña",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // INPUT DE CONTRASEÑA
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
                            color: AppColors.primaryBlue,
                          ),
                          labelText: 'Nueva contraseña',
                          labelStyle: const TextStyle(
                            color: AppColors.primaryBlue,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.accentGreen,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // BOTONES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.black),
                            label: const Text(
                              "Cancelar",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await user!.updatePassword(
                                  newPasswordController.text,
                                );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Contraseña actualizada exitosamente",
                                    ),
                                  ),
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Error al actualizar la contraseña",
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            label: const Text("Guardar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGreen,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget perfilInfoTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap, {
    bool isGreen = false,
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  isGreen
                      ? AppColors.accentGreen.withOpacity(0.1)
                      : AppColors.primaryBlue.withOpacity(0.1),
              child: Icon(
                icon,
                color:
                    isGreen
                        ? AppColors.accentGreen
                        : isDisabled
                        ? Colors.grey
                        : AppColors.primaryBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      appBar: const CustomAppBarSimple(
        title: "Mi Perfil",
        color: AppColors.primaryBlue,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
              ? Center(
                child: Text(error.isNotEmpty ? error : 'Usuario no encontrado'),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userData!["email"] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage("assets/images/profile.jpg"),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData!["name"] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Rol: ${userData!["role"] ?? 'Paciente'}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      child: const Text(
                        "Cambiar contraseña",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFB0BEC5)),

                    // Verificación médica si NO es admin
                    if (userData!["role"] != 'admin') ...[
                      if (userData!["role"] == 'doctor') ...[
                        perfilInfoTile(
                          Icons.verified,
                          "Verificación Médica",
                          "Verificado",
                          () => mostrarDialogoFelicidades(context),
                          isGreen: true,
                        ),
                      ] else ...[
                        perfilInfoTile(
                          Icons.verified,
                          "Verificación Médica",
                          "Sube tus credenciales",
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VerificarMedicoScreen(),
                            ),
                          ),
                        ),
                      ],
                    ],

                    perfilInfoTile(
                      Icons.history,
                      "Historial de Predicciones",
                      "Consulta anteriores análisis",
                      null,
                    ),
                    perfilInfoTile(
                      Icons.article,
                      "Mis Publicaciones",
                      "Casos médicos y debates",
                      null,
                    ),
                    perfilInfoTile(
                      Icons.settings,
                      "Configuración",
                      "Privacidad, notificaciones",
                      null,
                    ),
                    const Divider(color: Color(0xFFB0BEC5)),
                    perfilInfoTile(
                      Icons.info,
                      "Acerca de GenesApp",
                      "Descubre más sobre la app",
                      null,
                    ),
                    perfilInfoTile(
                      Icons.people,
                      "Desarrolladores",
                      "Conoce al equipo detrás de GenesApp",
                      null,
                    ),
                    perfilInfoTile(
                      Icons.policy,
                      "Política de Privacidad",
                      "Consulta nuestras normas",
                      null,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
    );
  }
}

void mostrarDialogoFelicidades(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, size: 60, color: AppColors.accentGreen),
              const SizedBox(height: 20),
              const Text(
                "¡Felicidades!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Ahora tienes acceso completo como médico en GenesApp.\nGracias por unirte como profesional de la salud.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "¡Entendido!",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
  );
}
