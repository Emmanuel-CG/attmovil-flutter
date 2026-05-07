import 'package:flutter/material.dart';
import 'package:automarket_mexico/screens/car_detail_screen.dart';

class CarCard extends StatelessWidget {
  final int id; // 👈 IMPORTANTE
  final String title;
  final String price;
  final String image;
  final String year;
  final String km;
  final String fuel;
  final String location;

  const CarCard({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.year,
    required this.km,
    required this.fuel,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CarDetailScreen(carId: id),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 IMAGEN
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.asset(
                "assets/images/car.png",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 CONTENIDO
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔹 TITULO
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 🔹 PRECIO
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xFFF4511E),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "MXN",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 🔹 INFO GRID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _info(Icons.calendar_today, year),
                      _info(Icons.speed, km),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _info(Icons.local_gas_station, fuel),
                      _info(Icons.location_on, location),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 🔹 DESCRIPCIÓN
                  const Text(
                    "Auto en buen estado",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 BOTÓN VISUAL
                  Row(
                    children: const [
                      Text(
                        "Ver detalles",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: Colors.blue),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}