import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const Text(
                "Mi Perfil",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Gestiona tu información personal y de seguridad",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _infoItem("Nombre", ""),
                    _divider(),
                    _infoItem("Email", ""),
                    _divider(),
                    _infoItem("Teléfono", ""),
                    _divider(),
                    _infoItem("Ubicación", ""),
                    _divider(),
                    _infoItem("Biografía", ""),
                  ],
                ),
              ),

              const SizedBox(height: 20),

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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Estado de tu cuenta",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.blue.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Cuenta verificada"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text("Información de la Cuenta",
                        style: TextStyle(fontWeight: FontWeight.w500)),

                    const SizedBox(height: 8),

                    const Text("Miembro desde: -"),
                    const Text("Autos publicados: -"),
                    const Text("Tiempo de respuesta: -"),

                    const SizedBox(height: 15),

                    Divider(color: Colors.grey.shade300),

                    const SizedBox(height: 10),

                    const Text("Documentos Verificados",
                        style: TextStyle(fontWeight: FontWeight.w500)),

                    const SizedBox(height: 10),

                    _docItem("INE / Pasaporte"),
                    _docItem("CURP"),
                    _docItem("RFC"),
                    _docItem("Comprobante de Domicilio"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cambiar Contraseña",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Actualiza tu contraseña de acceso",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Recomendamos cambiar tu contraseña regularmente para mantener tu cuenta segura.",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.lock_outline, size: 18),
                      label: const Text("Cambiar"),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300);
  }

  Widget _docItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          const Text(
            "Pendiente",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}