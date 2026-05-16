import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:automarket_mexico/services/auth_service.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() =>
      _AdminReportsScreenState();
}

class _AdminReportsScreenState
    extends State<AdminReportsScreen> {

  bool loading = true;

  List reports = [];

  int activeReports = 0;

  int resolvedReports = 0;

  @override
  void initState() {
    super.initState();

    fetchReports();
  }

  Future<void> fetchReports() async {

    try {

      final token =
          await AuthService.getToken();

      final response = await http.get(
        Uri.parse(
          "$API_BASE_URL/admin/reports",
        ),

        headers: {
          "Accept": "application/json",
          "Authorization": token ?? "",
        },
      );

      final data =
          jsonDecode(response.body);

      setState(() {

        reports = data;

        activeReports =
            reports.where((r) =>
                r["resolved"] == false)
            .length;

        resolvedReports =
            reports.where((r) =>
                r["resolved"] == true)
            .length;

        loading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        loading = false;
      });
    }
  }

  Color severityColor(String severity) {

    switch (severity) {

      case "high":
        return Colors.red;

      case "medium":
        return Colors.orange;

      default:
        return Colors.amber;
    }
  }

  String severityLabel(String severity) {

    switch (severity) {

      case "high":
        return "Alta";

      case "medium":
        return "Media";

      default:
        return "Baja";
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
          "Reportes",
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
              "Reportes y Alertas",
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Monitorea fraudes y problemas",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [

                Expanded(
                  child: reportCard(
                    title:
                        "Activos",

                    value:
                        "$activeReports",

                    icon:
                        Icons.error_outline,

                    color:
                        Colors.red,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: reportCard(
                    title:
                        "Resueltos",

                    value:
                        "$resolvedReports",

                    icon:
                        Icons.check_circle,

                    color:
                        Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: reportCard(
                    title:
                        "Total",

                    value:
                        "${reports.length}",

                    icon:
                        Icons.groups_outlined,

                    color:
                        Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            ListView.builder(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount:
                  reports.length,

              itemBuilder:
                  (context, index) {

                final report =
                    reports[index];

                final resolved =
                    report["resolved"] ==
                        true;

                final severity =
                    report["severity"];

                return Container(
                  margin:
                      const EdgeInsets.only(
                          bottom: 16),

                  padding:
                      const EdgeInsets.all(
                          18),

                  decoration:
                      BoxDecoration(
                    color: resolved
                        ? Colors.grey
                            .shade100
                        : severityColor(
                                severity)
                            .withOpacity(
                                0.08),

                    borderRadius:
                        BorderRadius.circular(
                            18),

                    border: Border(
                      left: BorderSide(
                        color: resolved
                            ? Colors.grey
                            : severityColor(
                                severity),

                        width: 4,
                      ),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                                0.03),

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
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  report["type"],

                                  style:
                                      const TextStyle(
                                    fontSize:
                                        18,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                        8),

                                Text(
                                  report[
                                      "description"],

                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                              width: 12),

                          Column(
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      14,

                                  vertical:
                                      6,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: resolved
                                      ? Colors.green
                                          .withOpacity(
                                              0.15)
                                      : Colors.blue
                                          .withOpacity(
                                              0.15),

                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),

                                child: Text(
                                  resolved
                                      ? "Resuelto"
                                      : "Pendiente",

                                  style:
                                      TextStyle(
                                    color: resolved
                                        ? Colors
                                            .green
                                        : Colors
                                            .blue,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  height:
                                      10),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      14,

                                  vertical:
                                      6,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: severityColor(
                                          severity)
                                      .withOpacity(
                                          0.15),

                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),

                                child: Text(
                                  severityLabel(
                                      severity),

                                  style:
                                      TextStyle(
                                    color:
                                        severityColor(
                                            severity),

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

                      const SizedBox(
                          height: 16),

                      Text(
                        "Reportado: ${report["date"]}",

                        style:
                            const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
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

Widget reportCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {

  return Container(
    padding: const EdgeInsets.all(18),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(18),

      boxShadow: [
        BoxShadow(
          color:
              Colors.black.withOpacity(0.04),

          blurRadius: 8,
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Icon(
          icon,
          color: color,
          size: 32,
        ),

        const SizedBox(height: 16),

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

          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}