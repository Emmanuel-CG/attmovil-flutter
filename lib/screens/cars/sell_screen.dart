  import 'package:automarket_mexico/screens/home_screen.dart';
  import 'package:flutter/material.dart';
  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'package:automarket_mexico/services/auth_service.dart';
  import 'package:automarket_mexico/screens/cars/my_cars_screen.dart';

  final API_BASE_URL = dotenv.env['API_URL']!;

  Future<bool> createCar(Map<String, dynamic> data) async {
    try {
      String? token = await AuthService.getToken();

      if (token == null) {
        print("No hay token");
        return false;
      }

      final response = await http.post(
        Uri.parse("$API_BASE_URL/cars"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": token, 
        },
        body: jsonEncode(data),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error conexión: $e");
      return false;
    }
  }

  class SellScreen extends StatefulWidget {
    const SellScreen({Key? key}) : super(key: key);

    @override
    State<SellScreen> createState() => _SellScreenState();
  }

  class _SellScreenState extends State<SellScreen> {
    final _formKey = GlobalKey<FormState>();

    String? selectedMarca;
    String? selectedTransmision;

    final modeloController = TextEditingController();
    final anioController = TextEditingController();
    final precioController = TextEditingController();
    final kmController = TextEditingController();
    final telefonoController = TextEditingController();

    final marcas = [
      "Toyota",
      "Honda",
      "Nissan",
      "Volkswagen",
      "Mazda",
      "Chevrolet",
      "Ford",
      "Hyundai",
      "Kia",
      "Otro",
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blue.shade50,

        appBar: AppBar(
          title: const Text("Vender Auto"),
        ),

        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.directions_car,
                            color: Colors.blue, size: 30),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Vende tu Auto",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Completa el formulario para publicar tu anuncio gratis",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Información del Vehículo",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 15),

                      _field("Marca *", _marcaDropdown()),
                      _field("Modelo *",
                          _input("Ej: Corolla, Civic", modeloController)),
                      _field("Año *", _input("2020", anioController)),
                      _field("Precio (MXN) *",
                          _input("250000", precioController)),
                      _field("Kilometraje *", _input("50000", kmController)),
                      _field("Transmisión", _transmisionDropdown()),
                      _field("Combustible", _input("Gasolina")),
                      _field("Color", _input("Blanco")),
                      _field("Ubicación", _input("Ciudad de México")),
                      _field("Teléfono",
                          _input("55 1234 5678", telefonoController)),

                      const SizedBox(height: 10),

                      const Text("Descripción"),
                      const SizedBox(height: 5),

                      TextFormField(
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Completa este campo";
                          }
                          return null;
                        },
                        decoration: _inputStyle("Describe tu auto..."),
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, color: Colors.grey),
                            SizedBox(height: 5),
                            Text("Haz clic para subir fotos"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                            );
                            },
                            child: const Text("Cancelar"),
                          ),
                        ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
    if (_formKey.currentState!.validate()) {

      final data = {
        "brand": selectedMarca,
        "model": modeloController.text,
        "year": int.tryParse(anioController.text) ?? 0,
        "price": int.tryParse(precioController.text) ?? 0,
        "mileage": int.tryParse(kmController.text) ?? 0,
        "transmission": selectedTransmision,
        "fuelType": "Gasolina",
        "color": "Blanco",
        "location": "México",
        "description": "Auto en buen estado",
        "phone": telefonoController.text,
      };

      bool success = await createCar(data);

      if (!mounted) return;

      if (success) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Auto publicado"),
      backgroundColor: Colors.green,
    ),
  );

  Future.delayed(const Duration(seconds: 1), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyCarsScreen(),
      ),
    );
  });
}else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al publicar "),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Publicar Anuncio"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _field(String label, Widget input) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 5),
            input,
          ],
        ),
      );
    }

    Widget _input(String hint, [TextEditingController? controller]) {
      return TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Completa este campo";
          }
          return null;
        },
        decoration: _inputStyle(hint),
      );
    }

    InputDecoration _inputStyle(String hint) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );
    }

    Widget _marcaDropdown() {
      return DropdownButtonFormField<String>(
        value: selectedMarca,
        hint: const Text("Selecciona la marca"),
        decoration: _inputStyle(""),
        validator: (value) {
          if (value == null) return "Completa este campo";
          return null;
        },
        items: marcas.map((marca) {
          return DropdownMenuItem(
            value: marca,
            child: Text(marca),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedMarca = value;
          });
        },
      );
    }

    Widget _transmisionDropdown() {
      final opciones = ["Manual", "Automática"];

      return DropdownButtonFormField<String>(
        value: selectedTransmision,
        hint: const Text("Selecciona transmisión"),
        decoration: _inputStyle(""),
        validator: (value) {
          if (value == null) return "Completa este campo";
          return null;
        },
        items: opciones.map((op) {
          return DropdownMenuItem(
            value: op,
            child: Text(op),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedTransmision = value;
          });
        },
      );
    }
  }