import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:automarket_mexico/services/auth_service.dart';

final API_BASE_URL = dotenv.env['API_URL']!;

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState
    extends State<AdminSettingsScreen> {

  bool loading = true;

  bool requireVerification = false;

  bool autoApprove = false;

  final TextEditingController platformCtrl =
      TextEditingController();

  final TextEditingController commissionCtrl =
      TextEditingController();

  final TextEditingController maxAdsCtrl =
      TextEditingController();

  final TextEditingController reputationCtrl =
      TextEditingController();

  final TextEditingController maxImageCtrl =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchSettings();
  }

  Future<void> fetchSettings() async {

    try {

      final token =
          await AuthService.getToken();

      final response = await http.get(
        Uri.parse(
          "$API_BASE_URL/admin/settings",
        ),

        headers: {
          "Accept": "application/json",
          "Authorization": token ?? "",
        },
      );

      final data =
          jsonDecode(response.body);

      setState(() {

        platformCtrl.text =
            data["platform_name"] ?? "";

        commissionCtrl.text =
            data["commission"]
                .toString();

        maxAdsCtrl.text =
            data["max_ads"]
                .toString();

        reputationCtrl.text =
            data["min_reputation"]
                .toString();

        maxImageCtrl.text =
            data["max_image_size"]
                .toString();

        requireVerification =
            data["require_verification"] ??
                false;

        autoApprove =
            data["auto_approve"] ?? false;

        loading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> saveSettings() async {

    try {

      final token =
          await AuthService.getToken();

      final response = await http.post(
        Uri.parse(
          "$API_BASE_URL/admin/settings",
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

          "platform_name":
              platformCtrl.text,

          "commission":
              commissionCtrl.text,

          "max_ads":
              maxAdsCtrl.text,

          "min_reputation":
              reputationCtrl.text,

          "max_image_size":
              maxImageCtrl.text,

          "require_verification":
              requireVerification,

          "auto_approve":
              autoApprove,
        }),
      );

      if (response.statusCode == 200) {

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Configuración guardada",
            ),
          ),
        );
      }

    } catch (e) {

      debugPrint(e.toString());
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
          "Configuración",
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
              "Configuración del Sistema",
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Personaliza los parámetros principales",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 24),

            settingsCard(
              title:
                  "Información General",

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  settingsLabel(
                    "Nombre de la Plataforma",
                  ),

                  const SizedBox(
                      height: 10),

                  settingsInput(
                    platformCtrl,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            settingsCard(
              title:
                  "Políticas de Comisión",

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  settingsLabel(
                    "Comisión (%)",
                  ),

                  const SizedBox(
                      height: 10),

                  settingsInput(
                    commissionCtrl,
                  ),

                  const SizedBox(
                      height: 20),

                  settingsLabel(
                    "Máximo de anuncios",
                  ),

                  const SizedBox(
                      height: 10),

                  settingsInput(
                    maxAdsCtrl,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            settingsCard(
              title:
                  "Verificación",

              child: Column(
                children: [

                  SwitchListTile(
                    value:
                        requireVerification,

                    onChanged: (value) {

                      setState(() {
                        requireVerification =
                            value;
                      });
                    },

                    activeColor:
                        Colors.blue,

                    title: const Text(
                      "Verificación requerida",
                    ),
                  ),

                  SwitchListTile(
                    value:
                        autoApprove,

                    onChanged: (value) {

                      setState(() {
                        autoApprove =
                            value;
                      });
                    },

                    activeColor:
                        Colors.blue,

                    title: const Text(
                      "Aprobación automática",
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  Align(
                    alignment:
                        Alignment.centerLeft,

                    child: settingsLabel(
                      "Reputación mínima",
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  settingsInput(
                    reputationCtrl,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            settingsCard(
              title:
                  "Archivos",

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  settingsLabel(
                    "Tamaño máximo de imagen",
                  ),

                  const SizedBox(
                      height: 10),

                  settingsInput(
                    maxImageCtrl,
                  ),

                  const SizedBox(
                      height: 20),

                  settingsLabel(
                    "Formatos permitidos",
                  ),

                  const SizedBox(
                      height: 8),

                  const Text(
                    "jpg, png, webp",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton.icon(

                onPressed:
                    saveSettings,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            16),
                  ),
                ),

                icon: const Icon(
                  Icons.save_outlined,
                  color: Colors.white,
                ),

                label: const Text(
                  "Guardar Cambios",

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.blue
                    .withOpacity(0.08),

                borderRadius:
                    BorderRadius.circular(
                        18),

                border: Border.all(
                  color: Colors.blue
                      .withOpacity(0.2),
                ),
              ),

              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Los cambios afectan toda la plataforma. Revisa cuidadosamente antes de guardar.",

                      style: TextStyle(
                        color: Colors.blue,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingsCard({
  required String title,
  required Widget child,
}) {

  return Container(
    width: double.infinity,

    padding: const EdgeInsets.all(22),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(20),

      boxShadow: [
        BoxShadow(
          color:
              Colors.black.withOpacity(0.04),

          blurRadius: 10,
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          title,

          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 24),

        child,
      ],
    ),
  );
}

Widget settingsLabel(String text) {

  return Text(
    text,

    style: const TextStyle(
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget settingsInput(
  TextEditingController controller,
) {

  return TextField(
    controller: controller,

    decoration: InputDecoration(
      filled: true,

      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide:
            const BorderSide(
          color: Colors.blue,
        ),
      ),
    ),
  );
}