import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Bienvenido al panel de administración de AutoMarket México",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.5,

              children: const [

                DashboardCard(
                  title: "Usuarios",
                  value: "1,248",
                  icon: Icons.group_outlined,
                  color: Colors.blue,
                ),

                DashboardCard(
                  title: "Autos Listados",
                  value: "856",
                  icon: Icons.directions_car_outlined,
                  color: Colors.green,
                ),

                DashboardCard(
                  title: "Ingresos",
                  value: "\$125,400",
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),

                DashboardCard(
                  title: "Reportes",
                  value: "12",
                  icon: Icons.description_outlined,
                  color: Colors.deepOrange,
                ),
              ],
            ),

            const SizedBox(height: 25),

            Column(
              children: [

                DashboardSection(
                  title: "Autos Recientes Pendientes",
                  color: Colors.blue,

                  items: const [
                    DashboardItem(
                      title: "Toyota Corolla",
                      subtitle: "Por: Juan Pérez",
                      time: "Hace 2 horas",
                    ),

                    DashboardItem(
                      title: "Honda Civic",
                      subtitle: "Por: María González",
                      time: "Hace 5 horas",
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                DashboardSection(
                  title: "Usuarios Nuevos",
                  color: Colors.green,

                  items: const [
                    DashboardItem(
                      title: "Carlos López",
                      subtitle: "carlos@example.com",
                      time: "Hoy",
                    ),

                    DashboardItem(
                      title: "Ana Rodríguez",
                      subtitle: "ana@example.com",
                      time: "Ayer",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardSection extends StatelessWidget {

  final String title;
  final Color color;
  final List<DashboardItem> items;

  const DashboardSection({
    super.key,
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 22),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: 4,
                    height: 75,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        item.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem {

  final String title;
  final String subtitle;
  final String time;

  const DashboardItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });
}