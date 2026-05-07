import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class CarDetailScreen extends StatefulWidget {
  final int carId;

  const CarDetailScreen({Key? key, required this.carId}) : super(key: key);

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  Map<String, dynamic>? car;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCar();
  }

  Future<void> fetchCar() async {
    try {
      final response = await http.get(
        Uri.parse("$API_BASE_URL/cars/${widget.carId}"),
      );

      if (response.statusCode == 200) {
        setState(() {
          car = jsonDecode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Detalle")),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔹 IMAGEN
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/car.png",
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 INFO CARD
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔹 TITULO + PRECIO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${car!['brand']} ${car!['model']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.share),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "\$${car!['price']}",
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 GRID INFO (igual que web)
Wrap(
  spacing: 25,
  runSpacing: 15,
  children: [
    _info(Icons.calendar_today, "Año", car!['year']?.toString() ?? ""),
    _info(Icons.speed, "Kilometraje", "${car!['mileage']?.toString() ?? ""} km"),
    _info(Icons.settings, "Transmisión", car!['transmission']?.toString() ?? ""),
    _info(Icons.local_gas_station, "Combustible", car!['fuelType']?.toString() ?? ""),
    _info(Icons.color_lens, "Color", car!['color']?.toString() ?? ""),
    _info(Icons.location_on, "Ubicación", car!['location']?.toString() ?? ""),
  ],
),

                  const SizedBox(height: 20),

                  // 🔹 DESCRIPCIÓN
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    car!['description'] ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // 🔹 VENDEDOR (como web derecha pero abajo)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Información del Vendedor",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 10),
                      Text(car!['sellerName']),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.phone)),
                      const SizedBox(width: 10),
                      Text(car!['sellerPhone']),
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone),
                      label: const Text("Contactar Vendedor"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Enviar Mensaje"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.blue),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}