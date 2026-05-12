import 'package:flutter/material.dart';

class AdminCarsScreen extends StatefulWidget {
  const AdminCarsScreen({super.key});

  @override
  State<AdminCarsScreen> createState() => _AdminCarsScreenState();
}

class _AdminCarsScreenState extends State<AdminCarsScreen> {

  String selectedStatus = "Todos los estados";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Autos",
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
              "Gestión de Autos",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Revisa, aprueba o rechaza los anuncios de autos publicados",
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

              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar por marca, modelo o vendedor...",

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

                  const SizedBox(width: 16),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),

                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),

                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          isExpanded: true,

                          items: const [

                            DropdownMenuItem(
                              value: "Todos los estados",
                              child: Text("Todos los estados"),
                            ),

                            DropdownMenuItem(
                              value: "Pendiente",
                              child: Text("Pendiente"),
                            ),

                            DropdownMenuItem(
                              value: "Aprobado",
                              child: Text("Aprobado"),
                            ),

                            DropdownMenuItem(
                              value: "Rechazado",
                              child: Text("Rechazado"),
                            ),
                          ],

                          onChanged: (value) {

                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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

                  carHeader(),

                  carRow(
                    car: "Toyota Corolla",
                    year: "2020",
                    price: "\$285,000",
                    seller: "Juan Pérez",
                    pending: true,
                    date: "2024-11-10",
                  ),

                  carRow(
                    car: "Honda Civic",
                    year: "2019",
                    price: "\$295,000",
                    seller: "María González",
                    pending: false,
                    date: "2024-11-08",
                  ),

                  carRow(
                    car: "Nissan Versa",
                    year: "2021",
                    price: "\$235,000",
                    seller: "Carlos Ramírez",
                    pending: true,
                    date: "2024-11-12",
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

Widget carHeader() {

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
            "Auto",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Text(
            "Año",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            "Precio",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            "Vendedor",
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
          flex: 2,
          child: Text(
            "Fecha",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,
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

Widget carRow({
  required String car,
  required String year,
  required String price,
  required String seller,
  required bool pending,
  required String date,
}) {

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 22,
      vertical: 16,
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
            car,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child: Text(year),
        ),

        Expanded(
          flex: 2,

          child: Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(seller),
        ),

        Expanded(
          flex: 2,

          child: Row(
            children: [

              Icon(
                pending
                    ? Icons.access_time_outlined
                    : Icons.check_circle_outline,

                color: pending
                    ? Colors.deepOrange
                    : Colors.green,

                size: 20,
              ),

              const SizedBox(width: 8),

              Text(
                pending
                    ? "Pendiente"
                    : "Aprobado",

                style: TextStyle(
                  color: pending
                      ? Colors.deepOrange
                      : Colors.green,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(date),
        ),

        Expanded(
          flex: 2,

          child: pending
              ? Row(
                  children: [

                    ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(40, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),

                      child: const Text(
                        "Aprobar",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(40, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),

                      child: const Text(
                        "Rechazar",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )

              : const SizedBox(),
        ),
      ],
    ),
  );
}