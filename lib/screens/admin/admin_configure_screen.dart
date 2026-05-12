import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState
    extends State<AdminSettingsScreen> {

  bool requireVerification = true;
  bool autoApprove = false;

  final TextEditingController platformCtrl =
      TextEditingController(text: "AutoMarket México");

  final TextEditingController commissionCtrl =
      TextEditingController(text: "5");

  final TextEditingController maxAdsCtrl =
      TextEditingController(text: "10");

  final TextEditingController reputationCtrl =
      TextEditingController(text: "0");

  final TextEditingController maxImageCtrl =
      TextEditingController(text: "5");

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Configuración",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Configuración del Sistema",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Personaliza los parámetros principales de AutoMarket México",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            settingsCard(
              title: "Información General",

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Nombre de la Plataforma",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  settingsInput(platformCtrl),
                ],
              ),
            ),

            const SizedBox(height: 22),

            settingsCard(
              title: "Políticas de Comisiones",

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Porcentaje de Comisión (%)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  settingsInput(commissionCtrl),

                  const SizedBox(height: 20),

                  const Text(
                    "Máximo de Anuncios por Usuario",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  settingsInput(maxAdsCtrl),
                ],
              ),
            ),

            const SizedBox(height: 22),

            settingsCard(
              title: "Políticas de Verificación",

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CheckboxListTile(
                    value: requireVerification,

                    onChanged: (value) {

                      setState(() {
                        requireVerification = value!;
                      });
                    },

                    activeColor: Colors.blue,

                    title: const Text(
                      "Verificación de Usuario Requerida",
                    ),

                    contentPadding: EdgeInsets.zero,
                  ),

                  CheckboxListTile(
                    value: autoApprove,

                    onChanged: (value) {

                      setState(() {
                        autoApprove = value!;
                      });
                    },

                    activeColor: Colors.blue,

                    title: const Text(
                      "Aprobar Anuncios Automáticamente",
                    ),

                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Reputación Mínima de Usuario",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  settingsInput(reputationCtrl),
                ],
              ),
            ),

            const SizedBox(height: 22),

            settingsCard(
              title: "Políticas de Archivos",

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Tamaño Máximo de Imagen (MB)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  settingsInput(maxImageCtrl),

                  const SizedBox(height: 20),

                  const Text(
                    "Formatos Permitidos",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "jpg, png, webp",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 55,

              child: ElevatedButton.icon(

                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Configuración guardada",
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),

                borderRadius: BorderRadius.circular(16),

                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),

              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Nota: Los cambios en la configuración afectan toda la plataforma. Asegúrate de revisar cuidadosamente antes de guardar.",

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
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

Widget settingsInput(TextEditingController controller) {

  return TextField(
    controller: controller,

    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.blue,
        ),
      ),
    ),
  );
}