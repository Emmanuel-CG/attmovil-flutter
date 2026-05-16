import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:automarket_mexico/services/auth_service.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class AdminCarsScreen extends StatefulWidget {
  const AdminCarsScreen({super.key});

  @override
  State<AdminCarsScreen> createState() =>
      _AdminCarsScreenState();
}

class _AdminCarsScreenState
    extends State<AdminCarsScreen> {

  bool loading = true;

  List cars = [];

  List filteredCars = [];

  String selectedStatus = "all";

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchCars();
  }

  Future<void> fetchCars() async {

    try {

      final token =
          await AuthService.getToken();

      final response = await http.get(
        Uri.parse(
          "$API_BASE_URL/admin/cars",
        ),

        headers: {
          "Accept": "application/json",
          "Authorization": token ?? "",
        },
      );

      final data =
          jsonDecode(response.body);

      setState(() {

        cars = data;

        filteredCars = data;

        loading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        loading = false;
      });
    }
  }

  void filterCars() {

    final query =
        searchController.text.toLowerCase();

    setState(() {

      filteredCars = cars.where((car) {

        final matchesSearch =

            car["brand"]
                .toString()
                .toLowerCase()
                .contains(query) ||

            car["model"]
                .toString()
                .toLowerCase()
                .contains(query) ||

            car["seller"]
                .toString()
                .toLowerCase()
                .contains(query);

        final matchesStatus =

            selectedStatus == "all" ||

            car["status"] ==
                selectedStatus;

        return matchesSearch &&
            matchesStatus;

      }).toList();
    });
  }

  Future<void> updateStatus(
    int id,
    String status,
  ) async {

    try {

      final token =
          await AuthService.getToken();

      final response = await http.patch(
        Uri.parse(
          "$API_BASE_URL/admin/cars/$id/status",
        ),

        headers: {
          "Content-Type":
              "application/json",

          "Accept":
              "application/json",

          "Authorization":
              token ?? "",
        },

        body: jsonEncode({
          "status": status,
        }),
      );

      if (response.statusCode == 200) {

        setState(() {

          for (var car in cars) {

            if (car["id"] == id) {

              car["status"] = status;
            }
          }
        });

        filterCars();
      }

    } catch (e) {

      debugPrint(e.toString());
    }
  }

  Color statusColor(String status) {

    switch (status) {

      case "approved":
        return Colors.green;

      case "rejected":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  IconData statusIcon(String status) {

    switch (status) {

      case "approved":
        return Icons.check_circle;

      case "rejected":
        return Icons.cancel;

      default:
        return Icons.access_time;
    }
  }

  String statusLabel(String status) {

    switch (status) {

      case "approved":
        return "Aprobado";

      case "rejected":
        return "Rechazado";

      default:
        return "Pendiente";
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Autos",
          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Gestión de Autos",
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Administra los autos publicados",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 22),

            Container(
              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(18),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.04),

                    blurRadius: 8,
                  ),
                ],
              ),

              child: Column(
                children: [

                  TextField(
                    controller:
                        searchController,

                    onChanged: (_) =>
                        filterCars(),

                    decoration: InputDecoration(
                      hintText:
                          "Buscar auto...",

                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: selectedStatus,

                    decoration:
                        InputDecoration(
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value: "all",
                        child: Text(
                          "Todos los estados",
                        ),
                      ),

                      DropdownMenuItem(
                        value: "pending",
                        child: Text(
                          "Pendiente",
                        ),
                      ),

                      DropdownMenuItem(
                        value: "approved",
                        child: Text(
                          "Aprobado",
                        ),
                      ),

                      DropdownMenuItem(
                        value: "rejected",
                        child: Text(
                          "Rechazado",
                        ),
                      ),
                    ],

                    onChanged: (value) {

                      selectedStatus =
                          value!;

                      filterCars();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            ListView.builder(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount:
                  filteredCars.length,

              itemBuilder:
                  (context, index) {

                final car =
                    filteredCars[index];

                final status =
                    car["status"];

                return Container(
                  margin:
                      const EdgeInsets.only(
                          bottom: 16),

                  padding:
                      const EdgeInsets.all(
                          18),

                  decoration:
                      BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                            20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                                0.04),

                        blurRadius: 8,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Row(
                        children: [

                          Container(
                            width: 60,
                            height: 60,

                            decoration:
                                BoxDecoration(
                              color: Colors.blue
                                  .withOpacity(
                                      0.1),

                              borderRadius:
                                  BorderRadius.circular(
                                      16),
                            ),

                            child: const Icon(
                              Icons
                                  .directions_car,
                              color:
                                  Colors.blue,
                            ),
                          ),

                          const SizedBox(
                              width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  "${car["brand"]} ${car["model"]}",

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize:
                                        18,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  "Año ${car["year"]}",

                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 18),

                      Text(
                        "\$${car["price"]}",

                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      Row(
                        children: [

                          const Icon(
                            Icons.person,
                            size: 18,
                            color:
                                Colors.grey,
                          ),

                          const SizedBox(
                              width: 8),

                          Text(
                            car["seller"],
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 12),

                      Row(
                        children: [

                          Icon(
                            statusIcon(
                                status),

                            color:
                                statusColor(
                                    status),

                            size: 20,
                          ),

                          const SizedBox(
                              width: 8),

                          Text(
                            statusLabel(
                                status),

                            style:
                                TextStyle(
                              color:
                                  statusColor(
                                      status),

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 12),

                      Text(
                        car["createdAt"],

                        style:
                            const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      if (status ==
                          "pending") ...[

                        const SizedBox(
                            height: 18),

                        Row(
                          children: [

                            Expanded(
                              child:
                                  ElevatedButton(
                                onPressed:
                                    () {

                                  updateStatus(
                                    car["id"],
                                    "approved",
                                  );
                                },

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green,

                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical:
                                        14,
                                  ),
                                ),

                                child:
                                    const Text(
                                  "Aprobar",
                                ),
                              ),
                            ),

                            const SizedBox(
                                width: 12),

                            Expanded(
                              child:
                                  ElevatedButton(
                                onPressed:
                                    () {

                                  updateStatus(
                                    car["id"],
                                    "rejected",
                                  );
                                },

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red,

                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical:
                                        14,
                                  ),
                                ),

                                child:
                                    const Text(
                                  "Rechazar",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}