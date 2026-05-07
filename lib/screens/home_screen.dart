import 'package:automarket_mexico/screens/buy_car_screen.dart';
import 'package:automarket_mexico/screens/login_screen.dart';
import 'package:automarket_mexico/screens/my_cars_screen.dart';
import 'package:automarket_mexico/screens/profile_screen.dart';
import 'package:automarket_mexico/screens/register_screen.dart';
import 'package:automarket_mexico/screens/sell_screen.dart';
import 'package:flutter/material.dart';
import 'package:automarket_mexico/widgets/card_car.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.directions_car, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "AutoMarket",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            drawerItem(
  icon: Icons.shopping_bag_outlined,
  text: "Comprar",
  onTap: () {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BuyScreen(),
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
        builder: (context) => const SellScreen(),
      ),
    );
  },
),

drawerItem(
  icon: Icons.directions_car,
  text: "Mis Autos",
  onTap: () {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyCarsScreen(),
      ),
    );
  },
),

            drawerItem(
              icon: Icons.login_outlined,
              text: "Iniciar Sesión",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),

            drawerItem(
              icon: Icons.person_outline,
               text: "Mi Perfil",
               onTap: () {
                Navigator.pop(context);
 
               Navigator.push(
                context,
               MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),

            const Spacer(),

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
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Registrarse"),
                ),
              ),
            ),
          ],
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
              child: const Icon(Icons.directions_car,
                  color: Colors.white, size: 22),
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
            image: "",
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