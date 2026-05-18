import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
// 🔹 CARRUSEL IMÁGENES
SizedBox(
  height: 240,

  child: // 🔹 CARRUSEL AUTO PLAY
CarouselSlider.builder(

  itemCount: car!['images'] != null
      ? car!['images'].length
      : 0,

  options: CarouselOptions(
    height: 240,

    autoPlay: true,

    autoPlayInterval:
        const Duration(seconds: 3),

    enlargeCenterPage: true,

    viewportFraction: 0.95,

    enableInfiniteScroll: true,
  ),

  itemBuilder:
      (context, index, realIndex) {

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(16),

      child: Image.network(
        car!['images'][index],

        width: double.infinity,
        fit: BoxFit.cover,

        loadingBuilder:
            (context, child, progress) {

          if (progress == null) {
            return child;
          }

          return Container(
            color: Colors.grey.shade200,

            child: const Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        },

        errorBuilder:
            (context, error, stackTrace) {

          return Image.asset(
            "assets/images/car.png",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  },
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
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

    Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            "${car!['brand']} ${car!['model']}",

            style: const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Vehículo publicado",

            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),

    PopupMenuButton<String>(

      icon: Container(
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),

          borderRadius:
              BorderRadius.circular(12),
        ),

        child: const Icon(
          Icons.flag_outlined,
          color: Colors.red,
        ),
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      elevation: 8,

      onSelected: (value) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "Reporte enviado: $value",
            ),
          ),
        );
      },

      itemBuilder: (context) => [

        PopupMenuItem(
          value:
              "Anuncio Fraudulento",

          child: Row(
            children: [

              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),

              const SizedBox(width: 12),

              const Text(
                "Anuncio Fraudulento",
              ),
            ],
          ),
        ),

        PopupMenuItem(
          value:
              "Usuario Sospechoso",

          child: Row(
            children: [

              const Icon(
                Icons.person_off_outlined,
                color: Colors.orange,
              ),

              const SizedBox(width: 12),

              const Text(
                "Usuario Sospechoso",
              ),
            ],
          ),
        ),

PopupMenuItem(
  value: "Fotos Inapropiadas",

  child: Row(
    children: [

      const Icon(
        Icons.hide_image_outlined,
        color: Colors.purple,
      ),

      const SizedBox(width: 12),

      const Text(
        "Fotos Inapropiadas",
      ),
    ],
  ),
),

        PopupMenuItem(
          value:
              "Precio Sospechoso",

          child: Row(
            children: [

              const Icon(
                Icons.attach_money,
                color: Colors.amber,
              ),

              const SizedBox(width: 12),

              const Text(
                "Precio Sospechoso",
              ),
            ],
          ),
        ),
      ],
    ),
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
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Contactar Vendedor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      car!['sellerName'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CARD TELÉFONO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [

                        const Text(
                          "Número de Teléfono",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          car!['sellerPhone'],
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: car!['sellerPhone'],
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Número copiado"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text("Copiar Número"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Puedes llamar o enviar un mensaje por WhatsApp a este número",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // BOTONES
                  Row(
                    children: [

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: car!['sellerPhone'],
                            );

                            await launchUrl(phoneUri);
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text("Llamar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final phone = car!['sellerPhone']
                                .toString()
                                .replaceAll(" ", "");

                            final Uri whatsappUrl = Uri.parse(
                              "https://wa.me/52$phone",
                            );

                            await launchUrl(
                              whatsappUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text("WhatsApp"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cerrar"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
    icon: const Icon(Icons.phone),
    label: const Text("Contactar Vendedor"),
  ),
),

                  const SizedBox(height: 10),
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