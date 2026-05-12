import 'package:flutter/material.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Reportes",
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
              "Reportes y Alertas",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Monitorea problemas, fraudes y violaciones de políticas",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [

                Expanded(
                  child: reportCard(
                    title: "Reportes Activos",
                    value: "2",
                    icon: Icons.error_outline,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: reportCard(
                    title: "Resueltos",
                    value: "2",
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: reportCard(
                    title: "Total",
                    value: "4",
                    icon: Icons.groups_outlined,
                    color: Colors.blue,
                  ),
                ),
              ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(22),

                    child: const Text(
                      "Lista de Reportes",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),

                  reportItem(
                    title: "Anuncio Fraudulento",
                    description:
                        "Posible estafa detectada en anuncio de Toyota Corolla",

                    date: "2024-11-12",

                    pending: true,
                    level: "Alta",
                  ),

                  reportItem(
                    title: "Usuario Sospechoso",
                    description:
                        "Múltiples reportes contra usuario user123",

                    date: "2024-11-11",

                    pending: true,
                    level: "Alta",
                  ),

                  reportItem(
                    title: "Fotos Inapropiadas",
                    description:
                        "Imágenes no relacionadas con el vehículo",

                    date: "2024-11-10",

                    pending: false,
                    level: "Media",
                  ),

                  reportItem(
                    title: "Precio Sospechoso",
                    description:
                        "Precio significativamente bajo comparado el mercado",

                    date: "2024-11-09",

                    pending: false,
                    level: "Baja",
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

Widget reportCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {

  return Container(
    padding: const EdgeInsets.all(18),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
        ),
      ],
    ),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        Icon(
          icon,
          color: color.withOpacity(0.3),
          size: 42,
        ),
      ],
    ),
  );
}

Widget reportItem({
  required String title,
  required String description,
  required String date,
  required bool pending,
  required String level,
}) {

  return Container(
    margin: const EdgeInsets.all(14),
    padding: const EdgeInsets.all(18),

    decoration: BoxDecoration(
      color: pending
          ? Colors.red.withOpacity(0.10)
          : Colors.grey.shade100,

      borderRadius: BorderRadius.circular(16),

      border: Border(
        left: BorderSide(
          color: pending
              ? Colors.red.shade300
              : Colors.grey.shade300,

          width: 4,
        ),
      ),
    ),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                description,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Reportado: $date",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        Column(
          children: [

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: pending
                    ? Colors.blue.withOpacity(0.15)
                    : Colors.green.withOpacity(0.15),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                pending
                    ? "Pendiente"
                    : "Resuelto",

                style: TextStyle(
                  color: pending
                      ? Colors.blue
                      : Colors.green,

                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                level,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}