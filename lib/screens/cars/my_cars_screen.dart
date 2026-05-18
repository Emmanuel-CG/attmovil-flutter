import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:automarket_mexico/services/auth_service.dart';
import 'package:automarket_mexico/widgets/card_car.dart';
import 'package:automarket_mexico/screens/cars/sell_screen.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class MyCarsScreen extends StatefulWidget {
  const MyCarsScreen({Key? key}) : super(key: key);

  @override
  State<MyCarsScreen> createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  List<dynamic> cars = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchMyCars();
  }

  Future<void> fetchMyCars() async {
    try {
      String? token = await AuthService.getToken();

      if (token == null) {
        print("No hay token");
        return;
      }

final response = await http.get(
  Uri.parse("$API_BASE_URL/cars/mine"),
  headers: {
    "Accept": "application/json",
    "Authorization": token,
  },
);

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          cars = data;
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      print("Error conexión: $e");
      setState(() => loading = false);
    }
  }

  Future<void> deleteCar(int id) async {
    try {
      String? token = await AuthService.getToken();

      final response = await http.delete(
        Uri.parse("$API_BASE_URL/cars/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": token ?? "",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          cars.removeWhere((car) => car['id'] == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Auto eliminado 🗑️")),
        );
      } else {
        print(response.body);
      }
    } catch (e) {
      print("Error eliminar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Mis Autos"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mis Autos",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Administra tus anuncios publicados",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text("Ver Contactos"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SellScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Publicar"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: cars.isEmpty
                      ? const Center(
                          child: Text("No tienes autos publicados"),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cars.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final car = cars[index];

                            return Stack(
                              children: [
                                CarCard(
                                  id: car['id'],
                                  title:
                                      "${car['brand']} ${car['model']}",
                                  price: "\$${car['price']}",
                                  image: car['images'] != null &&
        car['images'].isNotEmpty
    ? car['images'][0]
    : "",
                                  year: car['year'].toString(),
                                  km: "${car['mileage']} km",
                                  fuel: car['fuelType'] ?? "",
                                  location: car['location'] ?? "",
                                ),

                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Row(
                                    children: [
                                      _actionBtn(Icons.edit, Colors.blue),
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () =>
                                            deleteCar(car['id']),
                                        child: _actionBtn(
                                            Icons.delete, Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _actionBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}