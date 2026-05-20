import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool isVerified = false;

final TextEditingController nameController =
    TextEditingController();

final TextEditingController emailController =
    TextEditingController();

final TextEditingController phoneController =
    TextEditingController();

final TextEditingController locationController =
    TextEditingController();

final TextEditingController bioController =
    TextEditingController();

final TextEditingController curpController =
    TextEditingController();

final TextEditingController rfcController =
    TextEditingController();

final TextEditingController domicileController =
    TextEditingController();

    bool loading = true;

    @override
void initState() {
  super.initState();
  loadUser();
}

Future<void> loadUser() async {
  try {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse(
        "https://attm-backend-main-gvzubr.laravel.cloud/api/user",
      ),

      headers: {
        "Authorization": token ?? "",
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final user = data["user"];

      setState(() {

        nameController.text = user["name"] ?? "";

        emailController.text = user["email"] ?? "";

        phoneController.text = user["phone"] ?? "";

        locationController.text = user["location"] ?? "";

        bioController.text = user["bio"] ?? "";

        curpController.text = user["curp"] ?? "";

        rfcController.text = user["rfc"] ?? "";

        domicileController.text = user["domicile"] ?? "";

        isVerified = user["verified"] ?? false;

        loading = false;
      });
    }
  } catch (e) {

    setState(() {
      loading = false;
    });

    print(e);
  }
}

  void saveProfile() {
    setState(() {
      isEditing = false;

      isVerified = curpController.text.isNotEmpty &&
          rfcController.text.isNotEmpty &&
          domicileController.text.isNotEmpty;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Perfil actualizado"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Volver",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mi Perfil",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    child: Text(
                      isEditing ? "Cancelar" : "Editar",
                    ),
                  )
                ],
              ),

              const SizedBox(height: 5),

              const Text(
                "Gestiona tu información personal y de seguridad",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// PERFIL
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: Column(
                  children: [

                    isEditing
                        ? _input("Nombre", nameController)
                        : _infoItem("Nombre", nameController.text),

                    _divider(),

                    isEditing
                        ? _input("Email", emailController)
                        : _infoItem("Email", emailController.text),

                    _divider(),

                    isEditing
                        ? _input("Teléfono", phoneController)
                        : _infoItem("Teléfono", phoneController.text),

                    _divider(),

                    isEditing
                        ? _input("Ubicación", locationController)
                        : _infoItem("Ubicación", locationController.text),

                    _divider(),

                    isEditing
                        ? _input("Biografía", bioController)
                        : _infoItem("Biografía", bioController.text),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              if (isEditing)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: saveProfile,
                    child: const Text("Guardar Cambios"),
                  ),
                ),

              const SizedBox(height: 20),

              /// VERIFICACION
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Verificación y Seguridad",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Estado de tu cuenta",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: isVerified
                            ? Colors.green.shade50
                            : Colors.orange.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: isVerified
                              ? Colors.green.shade200
                              : Colors.orange.shade200,
                        ),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            isVerified
                                ? Icons.verified
                                : Icons.warning_amber_rounded,

                            color: isVerified
                                ? Colors.green
                                : Colors.orange,
                          ),

                          const SizedBox(width: 10),

                          Text(
                            isVerified
                                ? "Cuenta verificada"
                                : "Cuenta no verificada",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Información de la Cuenta",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text("Miembro desde: Mayo 2026"),
                    const Text("Autos publicados: 4"),
                    const Text("Tiempo de respuesta: 5 minutos"),

                    const SizedBox(height: 20),

                    Divider(color: Colors.grey.shade300),

                    const SizedBox(height: 15),

                    const Text(
                      "Datos de Verificación",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _verificationInput(
                      "CURP",
                      curpController,
                    ),

                    _verificationInput(
                      "RFC",
                      rfcController,
                    ),

                    _verificationInput(
                      "Comprobante de Domicilio",
                      domicileController,
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: saveProfile,
                        child: const Text(
                          "Guardar Verificación",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Cambiar Contraseña",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Actualiza tu contraseña de acceso",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _passwordInput("Contraseña Actual"),

                    const SizedBox(height: 12),

                    _passwordInput("Nueva Contraseña"),

                    const SizedBox(height: 12),

                    _passwordInput("Confirmar Contraseña"),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton.icon(
                        onPressed: () {},

                        icon: const Icon(Icons.lock_outline),

                        label: const Text(
                          "Cambiar Contraseña",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Flexible(
            child: Text(
              value.isEmpty ? "-" : value,

              textAlign: TextAlign.right,

              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300);
  }

  Widget _input(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: controller,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationInput(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: controller,

            decoration: InputDecoration(
              hintText: "Ingresa $label",

              filled: true,
              fillColor: Colors.grey[100],

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordInput(String hint) {
    return TextField(
      obscureText: true,

      decoration: InputDecoration(
        hintText: hint,

        filled: true,
        fillColor: Colors.grey[100],

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        suffixIcon: const Icon(Icons.visibility_off),
      ),
    );
  }
}