import 'dart:convert';
import 'package:automarket_mexico/widgets/card_car.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class BuyScreen extends StatefulWidget {
  const BuyScreen({Key? key}) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  List<dynamic> cars = [];
  bool loading = true;

  String search = "";
  String brand = "";
  String price = "";
  String order = "latest";

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    try {
      setState(() => loading = true);

      final uri = Uri.parse("$API_BASE_URL/cars/filter").replace(
        queryParameters: {
          if (search.isNotEmpty) "search": search,
          if (brand.isNotEmpty) "brand": brand,
          if (price.isNotEmpty) "price": price,
          if (order.isNotEmpty) "order": order,
        },
      );

      final response = await http.get(
        uri,
        headers: {"Accept": "application/json"},
      );

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
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Comprar Auto"),
      ),
      body: Column(
        children: [
          // 🔹 FILTROS
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.tune, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Filtros de Búsqueda",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 🔍 BUSCADOR
                TextField(
                  onChanged: (value) {
                    search = value;
                    fetchCars();
                  },
                  decoration: InputDecoration(
                    hintText: "Buscar marca, modelo...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [

                    // 🔹 MARCA
                    _dropdownFilter(
                      brand,
                      {
                        "Todas las marcas": "",
                        "Toyota": "Toyota",
                        "Honda": "Honda",
                        "Nissan": "Nissan",
                        "Volkswagen": "Volkswagen",
                        "Mazda": "Mazda",
                        "Chevrolet": "Chevrolet",
                      },
                      (value) {
                        setState(() {
                          brand = value;
                        });
                        fetchCars();
                      },
                    ),

                    // 🔹 PRECIO
                    _dropdownFilter(
                      price,
                      {
                        "Todos los precios": "",
                        "Hasta 200,000": "low",
                        "200,000 - 300,000": "mid",
                        "Más de 300,000": "high",
                      },
                      (value) {
                        setState(() {
                          price = value;
                        });
                        fetchCars();
                      },
                    ),

                    // 🔹 ORDEN
                    _dropdownFilter(
                      order,
                      {
                        "Más recientes": "latest",
                        "Precio Menor a Mayor": "price_asc",
                        "Precio Mayor a Menor": "price_desc",
                        "Año más reciente": "year",
                        "Menor kilometraje": "km",
                      },
                      (value) {
                        setState(() {
                          order = value;
                        });
                        fetchCars();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 LISTA
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : cars.isEmpty
                    ? const Center(child: Text("No hay autos disponibles"))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: cars.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.53,
                        ),
                        itemBuilder: (context, index) {
                          final car = cars[index];

return CarCard(
  id: car['id'],
  title: "${car['brand']} ${car['model']}",
  price: "\$${car['price']}",

  image: car['images'] ?? [],

  year: car['year'].toString(),
  km: "${car['mileage']} km",
  fuel: car['fuelType'] ?? "",
  location: car['location'] ?? "",
);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // 🔥 DROPDOWN CORREGIDO (SIN ERRORES)
  Widget _dropdownFilter(
    String currentValue,
    Map<String, String> options,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.values.contains(currentValue)
              ? currentValue
              : options.values.first,

          icon: const Icon(Icons.keyboard_arrow_down),

          items: options.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.key),
            );
          }).toList(),

          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}