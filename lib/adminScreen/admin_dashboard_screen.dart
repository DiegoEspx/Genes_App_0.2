import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:genesapp/widgets/app_colors.dart';
import 'package:genesapp/widgets/custom_app_bar_simple.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _roles = [
    'online',
    'all',
    'doctor',
    'patient',
    'articulos',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSimple(
        title: 'Panel Administrativo',
        color: AppColors.primaryBlue,
      ),
      body:
          _selectedIndex == 4
              ? _buildArticulosView()
              : ListaUsuariosPorRolScreen(rol: _roles[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.accentGreen,
        unselectedItemColor: AppColors.primaryBlue,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'En línea'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuarios'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Médicos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Pacientes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Artículos',
          ),
        ],
      ),
    );
  }

  Widget _buildArticulosView() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('articulos_medicos')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final articulos = snapshot.data!.docs;

        if (articulos.isEmpty) {
          return const Center(child: Text('No hay artículos publicados.'));
        }

        return ListView.builder(
          itemCount: articulos.length,
          itemBuilder: (context, index) {
            final data = articulos[index].data() as Map<String, dynamic>;

            final email = data['email'] ?? 'No especificado';
            final nombreArchivo =
                data['nombreArchivo'] ?? 'Archivo desconocido';
            final uid = data['uid'] ?? 'UID no registrado';
            final fechaTimestamp = data['fecha'];
            final fecha =
                fechaTimestamp is Timestamp
                    ? fechaTimestamp.toDate().toLocal().toString()
                    : 'Fecha inválida';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(nombreArchivo),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: $email"),
                    Text("Fecha: $fecha"),
                    Text("UID: $uid"),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ListaUsuariosPorRolScreen extends StatelessWidget {
  final String rol;

  const ListaUsuariosPorRolScreen({super.key, required this.rol});

  String _obtenerTitulo(String rol) {
    switch (rol) {
      case 'online':
        return 'Usuarios en línea';
      case 'doctor':
        return 'Médicos registrados';
      case 'patient':
        return 'Pacientes registrados';
      case 'all':
      default:
        return 'Todos los usuarios';
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final query =
        rol == 'all'
            ? usersRef
            : rol == 'online'
            ? usersRef.where('online', isEqualTo: true)
            : usersRef.where('role', isEqualTo: rol);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppColors.primaryBlue.withOpacity(0.1),
          child: Text(
            _obtenerTitulo(rol),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;

              if (users.isEmpty) {
                return const Center(child: Text('No se encontraron usuarios.'));
              }

              return ListView.builder(
                itemCount: users.length + 1, // +1 para el contador
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Total: ${users.length} usuario${users.length == 1 ? '' : 's'}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  }

                  final user = users[index - 1].data() as Map<String, dynamic>;
                  final email = user['email'] ?? 'Sin correo';
                  final name = user['name'] ?? 'Nombre no registrado';
                  final role = user['role'] ?? 'Rol desconocido';
                  final online = user['online'] == true;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(
                        online ? Icons.circle : Icons.account_circle,
                        color: online ? Colors.green : Colors.teal,
                      ),
                      title: Text(name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Email: $email"), Text("Rol: $role")],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
