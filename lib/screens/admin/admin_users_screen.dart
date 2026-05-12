import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Usuarios",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Gestión de Usuarios",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Administra y supervisa todos los usuarios de la plataforma",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar por nombre o email...",

                  prefixIcon: const Icon(
                    Icons.search,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(
                children: [

                  userRowHeader(),

                  userRow(
                    name: "Juan Pérez",
                    email: "juan@example.com",
                    phone: "55-1234-5678",
                    verified: true,
                    cars: "3",
                    active: true,
                  ),

                  userRow(
                    name: "María González",
                    email: "maria@example.com",
                    phone: "33-9876-5432",
                    verified: false,
                    cars: "1",
                    active: true,
                  ),

                  userRow(
                    name: "Carlos Ramírez",
                    email: "carlos@example.com",
                    phone: "81-5555-1234",
                    verified: true,
                    cars: "2",
                    active: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget userRowHeader() {

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 22,
      vertical: 18,
    ),

    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
    ),

    child: const Row(
      children: [

        Expanded(
          flex: 2,
          child: Text(
            "Nombre",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 3,
          child: Text(
            "Email",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            "Teléfono",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            "Verificado",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Text(
            "Autos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            "Estado",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Text(
            "Acciones",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget userRow({
  required String name,
  required String email,
  required String phone,
  required bool verified,
  required String cars,
  required bool active,
}) {

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 22,
      vertical: 20,
    ),

    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
    ),

    child: Row(
      children: [

        Expanded(
          flex: 2,

          child: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          flex: 3,

          child: Text(
            email,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),

        Expanded(
          flex: 2,

          child: Text(
            phone,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),

        Expanded(
          flex: 2,

          child: Row(
            children: [

              Icon(
                verified
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,

                color: verified
                    ? Colors.green
                    : Colors.deepOrange,

                size: 20,
              ),

              const SizedBox(width: 6),

              Text(
                verified ? "Sí" : "No",

                style: TextStyle(
                  color: verified
                      ? Colors.green
                      : Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Text(
            cars,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,

          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: active
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              active
                  ? "Activo"
                  : "Suspendido",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: active
                    ? Colors.green
                    : Colors.red,

                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const Expanded(
          child: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}