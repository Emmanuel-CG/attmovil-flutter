import 'dart:io';
import 'package:automarket_mexico/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:automarket_mexico/services/auth_service.dart';
import 'package:automarket_mexico/screens/cars/my_cars_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

final API_BASE_URL = dotenv.env['API_URL']!;

Future<bool> createCar(
  Map<String, dynamic> data,
  List<XFile> images,
) async {
  try {
    String? token = await AuthService.getToken();

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$API_BASE_URL/cars"),
    );

    request.headers["Accept"] = "application/json";
    request.headers["Authorization"] = token ?? "";

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "images[]",
          image.path,
        ),
      );
    }

    final response = await request.send();

    print(response.statusCode);

    return response.statusCode == 200 ||
        response.statusCode == 201;
  } catch (e) {
    print(e);
    return false;
  }
}

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() =>
      _SellScreenState();
}

class _SellScreenState
    extends State<SellScreen> {

  final _formKey = GlobalKey<FormState>();

  List<XFile> images = [];

  final picker = ImagePicker();

  String? selectedMarca;
  String? selectedTransmision;

  final modeloController =
      TextEditingController();

  final anioController =
      TextEditingController();

  final precioController =
      TextEditingController();

  final kmController =
      TextEditingController();

  final telefonoController =
      TextEditingController();

  final descripcionController =
      TextEditingController();

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

  Future<void> pickImages() async {

    final List<XFile> selected =
        await picker.pickMultiImage();

    if (selected.isNotEmpty) {

      if (selected.length > 3) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
                Text("Máximo 3 imágenes"),
          ),
        );

        return;
      }

      setState(() {
        images = selected;
      });
    }
  }


bool loading = false;

double? aiPrice;

Future<void> getAIPrediction() async {

  try {

    if (
      selectedMarca == null ||
      modeloController.text.isEmpty ||
      anioController.text.isEmpty ||
      kmController.text.isEmpty ||
      selectedTransmision == null
    ) {
      return;
    }

    String transmission =
        selectedTransmision!;

    if (transmission == "Automática") {
      transmission = "Automatic";
    }

    final response = await http.post(
      Uri.parse(
        "https://automarket-ia.onrender.com/predict",
      ),

      headers: {
        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "Brand": selectedMarca,

        "Model":
            modeloController.text,

        "Model_Ye": int.tryParse(
              anioController.text,
            ) ??
            0,

        "Kilometer": int.tryParse(
              kmController.text,
            ) ??
            0,

        "Fuel_Type": "Petrol",

        "Transmiss": transmission,
      }),
    );

    final data =
        jsonDecode(response.body);

    setState(() {

      aiPrice =
          (data["price"] as num)
              .toDouble();
    });

  } catch (e) {

    print(e);
  }
}

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
                padding:
                    const EdgeInsets.all(16),

                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color:
                            Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Vende tu Auto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Completa el formulario para publicar tu anuncio gratis",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Container(
                margin: const EdgeInsets.all(16),

                padding:
                    const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Información del Vehículo",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _field(
                      "Marca *",
                      _marcaDropdown(),
                    ),

                    _field(
                      "Modelo *",
                      _input(
                        "Ej: Corolla",
                        modeloController,
                      ),
                    ),

                    _field(
                      "Año *",
                      _input(
                        "2020",
                        anioController,
                      ),
                    ),
                    if (aiPrice != null)
  Container(
    width: double.infinity,

    padding:
        const EdgeInsets.all(16),

    margin:
        const EdgeInsets.only(
      bottom: 12,
    ),

    decoration: BoxDecoration(
      borderRadius:
          BorderRadius.circular(16),

      gradient: LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
      ),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(
          "Precio sugerido por IA",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          "\$${aiPrice!.toStringAsFixed(0)} MXN",

          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          "Basado en vehículos similares del mercado",

          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    ),
  ),

                    _field(
                      "Precio *",
                      _input(
                        "250000",
                        precioController,
                      ),
                    ),

                    _field(
                      "Kilometraje *",
                      _input(
                        "50000",
                        kmController,
                      ),
                    ),

                    _field(
                      "Transmisión",
                      _transmisionDropdown(),
                    ),

                    _field(
                      "Teléfono",
                      _input(
                        "55 1234 5678",
                        telefonoController,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text("Descripción"),

                    const SizedBox(height: 5),

                    TextFormField(
                      controller:
                          descripcionController,

                      maxLines: 3,

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Completa este campo";
                        }
                        return null;
                      },

                      decoration:
                          _inputStyle(
                        "Describe tu auto...",
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: pickImages,

                      child: Container(
                        width: double.infinity,

                        padding:
                            const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.grey[100],

                          borderRadius:
                              BorderRadius.circular(12),

                          border: Border.all(
                            color:
                                Colors.grey.shade300,
                          ),
                        ),

                        child: Column(
                          children: [

                            const Icon(
                              Icons.upload,
                              size: 40,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Haz clic para subir fotos",
                            ),

                            const SizedBox(height: 15),

                            if (images.isNotEmpty)
                              SizedBox(
                                height: 100,

                                child:
                                    ListView.builder(
                                  scrollDirection:
                                      Axis.horizontal,

                                  itemCount:
                                      images.length,

                                  itemBuilder:
                                      (context, index) {

                                    return Container(
                                      margin:
                                          const EdgeInsets.only(
                                        right: 10,
                                      ),

                                      child:
                                          ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                          12,
                                        ),

                                        child:
                                            Image.file(
                                          File(
                                            images[index]
                                                .path,
                                          ),

                                          width: 120,
                                          height: 100,

                                          fit:
                                              BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
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

                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeScreen(),
                                ),

                                (route) => false,
                              );
                            },

                            child:
                                const Text("Cancelar"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
  child: ElevatedButton(

    onPressed: loading
        ? null
        : () async {

            if (_formKey.currentState!
                .validate()) {

              setState(() {
                loading = true;
              });

              final data = {

                "brand":
                    selectedMarca,

                "model":
                    modeloController.text,

                "year":
                    int.tryParse(
                          anioController.text,
                        ) ??
                        0,

                "price":
                    int.tryParse(
                          precioController.text,
                        ) ??
                        0,

                "mileage":
                    int.tryParse(
                          kmController.text,
                        ) ??
                        0,

                "transmission":
                    selectedTransmision,

                "fuelType":
                    "Gasolina",

                "color":
                    "Blanco",

                "location":
                    "México",

                "description":
                    descripcionController.text,

                "phone":
                    telefonoController.text,
              };

              bool success =
                  await createCar(
                data,
                images,
              );

              if (!mounted) return;

              setState(() {
                loading = false;
              });

              if (success) {

                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Auto publicado",
                    ),

                    backgroundColor:
                        Colors.green,
                  ),
                );

                Future.delayed(
                  const Duration(
                    seconds: 1,
                  ),

                  () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const MyCarsScreen(),
                      ),
                    );
                  },
                );

              } else {

                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Error al publicar",
                    ),

                    backgroundColor:
                        Colors.red,
                  ),
                );
              }
            }
          },

    style:
        ElevatedButton.styleFrom(
      backgroundColor:
          Colors.blue,

      foregroundColor:
          Colors.white,
    ),

    child: loading
        ? const SizedBox(
            width: 20,
            height: 20,

            child:
                CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Text(
            "Publicar",
          ),
  ),
)
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

  Widget _field(
    String label,
    Widget input,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          input,
        ],
      ),
    );
  }

  Widget _input(
    String hint,
    [TextEditingController? controller]
  ) {
    return TextFormField(
      controller: controller,

    onChanged: (_) => getAIPrediction(),

      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return "Completa este campo";
        }
        return null;
      },

      decoration: _inputStyle(hint),
    );
  }

  InputDecoration _inputStyle(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,

      filled: true,

      fillColor: Colors.grey[100],

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _marcaDropdown() {

    return DropdownButtonFormField<String>(

      value: selectedMarca,

      hint:
          const Text("Selecciona marca"),

      decoration: _inputStyle(""),

      validator: (value) {
        if (value == null) {
          return "Completa este campo";
        }
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
         getAIPrediction();
      },
    );
  }

  Widget _transmisionDropdown() {

    final opciones = [
      "Manual",
      "Automática",
    ];

    return DropdownButtonFormField<String>(

      value: selectedTransmision,

      hint: const Text(
        "Selecciona transmisión",
      ),

      decoration: _inputStyle(""),

      validator: (value) {
        if (value == null) {
          return "Completa este campo";
        }
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
        getAIPrediction();
      },
    );
  }
}