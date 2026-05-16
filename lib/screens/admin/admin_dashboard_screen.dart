import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:automarket_mexico/services/auth_service.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {

  final String apiUrl =
      "$API_BASE_URL/admin/dashboard";

  bool loading = true;

  Map<String, dynamic> stats = {};

  List recentCars = [];

  List recentUsers = [];

  @override
  void initState() {
    super.initState();

    fetchDashboard();
  }

  Future<void> fetchDashboard() async {

    try {

      final token =
          await AuthService.getToken();

      final response = await http.get(
        Uri.parse(apiUrl),

        headers: {
          "Accept": "application/json",
          "Authorization": token ?? "",
        },
      );

      final data =
          jsonDecode(response.body);

      setState(() {

        stats = data["stats"];

        recentCars =
            data["recentCars"];

        recentUsers =
            data["recentUsers"];

        loading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Panel de administración",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 22),

            GridView(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.4,
              ),

              children: [

                DashboardCard(
                  title: "Usuarios",
                  value:
                      "${stats["users"] ?? 0}",
                  icon: Icons.group_outlined,
                  color: Colors.blue,
                ),

                DashboardCard(
                  title: "Autos",
                  value:
                      "${stats["cars"] ?? 0}",
                  icon:
                      Icons.directions_car_outlined,
                  color: Colors.green,
                ),

                DashboardCard(
                  title: "Reportes",
                  value:
                      "${stats["reports"] ?? 0}",
                  icon:
                      Icons.description_outlined,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 24),

            DashboardSection(
              title: "Autos recientes",
              color: Colors.blue,

              children: recentCars.map((car) {

                return DashboardItemWidget(
                  title:
                      "${car["brand"]} ${car["model"]}",

                  subtitle:
                      "Por: ${car["seller"]}",

                  time:
                      car["created_at"] ?? "",
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            DashboardSection(
              title: "Usuarios nuevos",
              color: Colors.green,

              children: recentUsers.map((user) {

                return DashboardItemWidget(
                  title:
                      user["name"],

                  subtitle:
                      user["email"],

                  time:
                      user["created_at"] ?? "",
                );
              }).toList(),
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
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),

            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color,

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,

                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardSection extends StatelessWidget {

  final String title;

  final Color color;

  final List<Widget> children;

  const DashboardSection({
    super.key,
    required this.title,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),

            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 22),

          ...children,
        ],
      ),
    );
  }
}

class DashboardItemWidget
    extends StatelessWidget {

  final String title;

  final String subtitle;

  final String time;

  const DashboardItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            width: 4,
            height: 60,

            decoration: BoxDecoration(
              color: Colors.blue,

              borderRadius:
                  BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,

                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}