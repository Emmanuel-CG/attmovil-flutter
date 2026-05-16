import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:automarket_mexico/services/auth_service.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() =>
      _AdminUsersScreenState();
}

class _AdminUsersScreenState
    extends State<AdminUsersScreen> {

  bool loading = true;

  List users = [];

  List filteredUsers = [];

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchUsers();
  }

  Future<void> fetchUsers() async {

    try {

      final token =
          await AuthService.getToken();

      final response = await http.get(
        Uri.parse(
          "$API_BASE_URL/admin/users",
        ),

        headers: {
          "Accept": "application/json",
          "Authorization": token ?? "",
        },
      );

      final data =
          jsonDecode(response.body);

      setState(() {

        users = data;

        filteredUsers = data;

        loading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        loading = false;
      });
    }
  }

  void filterUsers(String value) {

    setState(() {

      filteredUsers = users.where((user) {

        final name =
            user["name"]
                .toString()
                .toLowerCase();

        final email =
            user["email"]
                .toString()
                .toLowerCase();

        return name.contains(
                  value.toLowerCase(),
                ) ||
            email.contains(
              value.toLowerCase(),
            );
      }).toList();
    });
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
          "Usuarios",
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
              "Gestión de Usuarios",
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Administra todos los usuarios",
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

              child: TextField(
                controller:
                    searchController,

                onChanged: filterUsers,

                decoration: InputDecoration(
                  hintText:
                      "Buscar usuario...",

                  prefixIcon:
                      const Icon(
                    Icons.search,
                  ),

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                            16),

                    borderSide:
                        BorderSide(
                      color:
                          Colors.grey
                              .shade300,
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                            16),

                    borderSide:
                        BorderSide(
                      color:
                          Colors.grey
                              .shade300,
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                            16),

                    borderSide:
                        const BorderSide(
                      color:
                          Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            ListView.builder(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount:
                  filteredUsers.length,

              itemBuilder:
                  (context, index) {

                final user =
                    filteredUsers[index];

                final verified =
                    user["verified"] ==
                        true;

                final active =
                    user["status"] ==
                        "activo";

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

                          CircleAvatar(
                            radius: 24,

                            backgroundColor:
                                Colors.blue
                                    .withOpacity(
                                        0.15),

                            child: Text(
                              user["name"][0],

                              style:
                                  const TextStyle(
                                color:
                                    Colors
                                        .blue,

                                fontWeight:
                                    FontWeight
                                        .bold,

                                fontSize:
                                    18,
                              ),
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
                                  user["name"],

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
                                  user["email"],

                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.more_vert,
                            color:
                                Colors.grey,
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 18),

                      Row(
                        children: [

                          const Icon(
                            Icons.phone_outlined,
                            size: 18,
                            color:
                                Colors.grey,
                          ),

                          const SizedBox(
                              width: 8),

                          Text(
                            user["phone"] ??
                                "",
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 14),

                      Row(
                        children: [

                          Icon(
                            verified
                                ? Icons
                                    .check_circle
                                : Icons
                                    .cancel,

                            color: verified
                                ? Colors
                                    .green
                                : Colors.red,

                            size: 20,
                          ),

                          const SizedBox(
                              width: 8),

                          Text(
                            verified
                                ? "Verificado"
                                : "No verificado",

                            style: TextStyle(
                              color: verified
                                  ? Colors
                                      .green
                                  : Colors
                                      .red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 14),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          Text(
                            "Autos: ${user["totalCars"]}",

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  14,

                              vertical: 6,
                            ),

                            decoration:
                                BoxDecoration(
                              color: active
                                  ? Colors.green
                                      .withOpacity(
                                          0.15)
                                  : Colors.red
                                      .withOpacity(
                                          0.15),

                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),

                            child: Text(
                              active
                                  ? "Activo"
                                  : "Suspendido",

                              style:
                                  TextStyle(
                                color: active
                                    ? Colors
                                        .green
                                    : Colors
                                        .red,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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