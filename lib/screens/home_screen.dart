import 'package:automarket_mexico/screens/admin/admin_cars_screen.dart';
import 'package:automarket_mexico/screens/admin/admin_configure_screen.dart';
import 'package:automarket_mexico/screens/admin/admin_dashboard_screen.dart';
import 'package:automarket_mexico/screens/admin/admin_reports_screen.dart';
import 'package:automarket_mexico/screens/admin/admin_users_screen.dart';
import 'package:automarket_mexico/screens/cars/buy_car_screen.dart';
import 'package:automarket_mexico/screens/auth/login_screen.dart';
import 'package:automarket_mexico/screens/cars/my_cars_screen.dart';
import 'package:automarket_mexico/screens/profile/profile_screen.dart';
import 'package:automarket_mexico/screens/auth/register_screen.dart';
import 'package:automarket_mexico/screens/cars/sell_screen.dart';
import 'package:flutter/material.dart';
import 'package:automarket_mexico/widgets/card_car.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:automarket_mexico/services/auth_service.dart';
final API_BASE_URL = dotenv.env['API_URL']!;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  List cars = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    try {
      final response = await http.get(
        Uri.parse("$API_BASE_URL/cars"),
      );

      if (response.statusCode == 200) {
        setState(() {
          cars = jsonDecode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
drawer: Drawer(
  child: FutureBuilder<Map<String, dynamic>?>(
    future: AuthService.getUser(),

    builder: (context, snapshot) {

      final user = snapshot.data;
      final isAdmin =
    user != null &&
    user["role"].toString().toLowerCase() == "admin";

      return Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF42A5F5),
                ],
              ),
            ),

            child: Column(
              children: [

                const Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 40,
                ),

                const SizedBox(height: 10),

                const Text(
                  "AutoMarket",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // USUARIO LOGEADO
                if (user != null) ...[

                  const SizedBox(height: 15),

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,

                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    user["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    user["email"],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

const SizedBox(height: 20),

// ADMIN
if (isAdmin) ...[

drawerItem(
  icon: Icons.dashboard_outlined,
  text: "Dashboard",
  onTap: () {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminDashboardScreen(),
      ),
    );
  },
),

drawerItem(
  icon: Icons.group_outlined,
  text: "Usuarios",
  onTap: () {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminUsersScreen(),
      ),
    );
  },
),

drawerItem(
  icon: Icons.directions_car_outlined,
  text: "Autos",
  onTap: () {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminCarsScreen(),
      ),
    );
  },
),

drawerItem(
  icon: Icons.description_outlined,
  text: "Reportes",
  onTap: () {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminReportsScreen(),
      ),
    );
  },
),

drawerItem(
  icon: Icons.settings_outlined,
  text: "Configuración",
  onTap: () {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminSettingsScreen(),
      ),
    );
  },
),
]

// USUARIO NORMAL
else ...[

  drawerItem(
    icon: Icons.shopping_bag_outlined,
    text: "Comprar",
    onTap: () {

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const BuyScreen(),
        ),
      );
    },
  ),

  drawerItem(
    icon: Icons.sell_outlined,
    text: "Vender",
    onTap: () {

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SellScreen(),
        ),
      );
    },
  ),

  if (user != null)

    drawerItem(
      icon: Icons.directions_car,
      text: "Mis Autos",
      onTap: () {

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MyCarsScreen(),
          ),
        );
      },
    ),

  if (user == null)

    drawerItem(
      icon: Icons.login_outlined,
      text: "Iniciar Sesión",
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
    ),

  if (user != null)

    drawerItem(
      icon: Icons.person_outline,
      text: "Mi Perfil",
      onTap: () {

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
        );
      },
    ),
],
          const Spacer(),

          // SIN LOGIN
          if (user == null)

            Padding(
              padding: const EdgeInsets.all(20),

              child: SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    "Registrarse",
                  ),
                ),
              ),
            ),

          // CON LOGIN
          if (user != null)

            Padding(
              padding: const EdgeInsets.all(20),

              child: SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton.icon(

                  onPressed: () async {

                    await AuthService.logout();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  icon: const Icon(Icons.logout),

                  label: const Text(
                    "Cerrar Sesión",
                  ),
                ),
              ),
            ),
        ],
      );
    },
  ),
),

      appBar: AppBar(
  toolbarHeight: 70,
  backgroundColor: Colors.white,
  elevation: 1,
  iconTheme: const IconThemeData(color: Colors.black),

  title: Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 22,
        ),
      ),

      const SizedBox(width: 12),

      const Text(
        "AutoMarket",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ],
  ),

  actions: [

    FutureBuilder<Map<String, dynamic>?>(
      future: AuthService.getUser(),

      builder: (context, snapshot) {

        final user = snapshot.data;

        // SI HAY SESIÓN
        if (user != null) {

          return Padding(
            padding: const EdgeInsets.only(right: 12),

            child: GestureDetector(

  onTap: () {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  },

  child: CircleAvatar(
    backgroundColor: Colors.blue,

              child: Text(
                user["name"][0].toUpperCase(),

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ),
          );
        }

        // SI NO HAY SESIÓN
        return TextButton.icon(

          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },

          icon: const Icon(
            Icons.login,
            color: Colors.blue,
          ),

          label: const Text(
            "Iniciar sesión",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    ),
  ],
),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Encuentra el auto perfecto para ti",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Miles de autos verificados, precios transparentes y la mejor experiencia en México",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                          ),
                          child: const Text("Explorar Autos"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                          child: const Text("Vender mi Auto"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(child: StatItem("5,000+", "Autos")),
                      Expanded(child: StatItem("98%", "Clientes")),
                      Expanded(child: StatItem("24/7", "Soporte")),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "¿Por qué AutoMarket?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "La forma más segura y confiable de comprar y vender autos en México",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  BenefitCard(
                    icon: Icons.shield_outlined,
                    title: "100% Seguro",
                    description: "Verificamos cada anuncio",
                  ),
                  SizedBox(height: 12),
                  BenefitCard(
                    icon: Icons.directions_car,
                    title: "Gran Variedad",
                    description: "Miles de autos disponibles",
                  ),
                  SizedBox(height: 12),
                  BenefitCard(
                    icon: Icons.trending_up,
                    title: "Mejor Precio",
                    description: "Precios sin comisiones",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Autos Destacados",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 5),

      const Text(
        "Las mejores ofertas seleccionadas para ti",
        style: TextStyle(color: Colors.grey),
      ),

      const SizedBox(height: 15),

      SizedBox(
        height: 380,
        child: loading
    ? const Center(child: CircularProgressIndicator())
    : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];

          return CarCard(
            id: car['id'],
            title: "${car['brand']} ${car['model']}",
            price: "\$${car['price']}",
            image: car['image'] != null &&
            car['image'].isNotEmpty
            ? car['images'][0]
            : "",
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
),


const SizedBox(height: 20),

Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 16),
  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [
        Color(0xFF000000),
        Color(0xFF1C1C1C),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.people_alt_outlined,
          color: Colors.orange,
          size: 28,
        ),
      ),

      const SizedBox(height: 20),

      const Text(
        "¿Tienes un auto para vender?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 10),

      const Text(
        "Publica tu anuncio gratis en minutos y conecta con miles de compradores interesados en toda la república",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),

      const SizedBox(height: 25),

      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Publicar Anuncio Gratis"),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 16),
          ],
        ),
      ),
    ],
  ),
),

Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
  color: Colors.grey[100],
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "AutoMarket",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),

      const Text(
        "© 2025 AutoMarket México",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
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

// 🔹 DRAWER ITEM
Widget drawerItem({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.blue),
    title: Text(text),
    onTap: onTap,
  );
}

// 🔹 STATS
class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem(this.value, this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}

// 🔹 BENEFITS
class BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BenefitCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(description,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}