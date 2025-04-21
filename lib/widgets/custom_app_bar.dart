import 'package:flutter/material.dart';
import 'package:genesapp/usersScreen/perfil.dart';
import 'package:genesapp/widgets/app_colors.dart';

class CustomAppBarWithDrawer extends StatelessWidget
    implements PreferredSizeWidget {
  final String title; // Si quieres personalizarlo en otro lado
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBarWithDrawer({
    super.key,
    this.title = "Guías de ayuda",
    required this.color,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue, color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Logo izquierdo (Drawer)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => scaffoldKey.currentState?.openDrawer(),
                child: Image.asset(
                  "assets/images/genesappLogo-removebg-preview.png",
                  width: 50,
                  height: 50,
                ),
              ),
            ),

            /// Título centrado
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            /// Botón de perfil a la derecha
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
