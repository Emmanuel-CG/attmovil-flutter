import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:automarket_mexico/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_links/app_links.dart';
import 'package:automarket_mexico/screens/auth/reset_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    initDeepLinks();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkTerms();
    });
  }

  void initDeepLinks() async {
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        handleLink(uri);
      }
    });

    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) {
      handleLink(uri);
    }
  }

  void handleLink(Uri uri) {
    if (uri.path == "/reset-password") {
      final token = uri.queryParameters['token'];

      if (token != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(
                email: "",
                token: token,
              ),
            ),
          );
        });
      }
    }
  }

  Future<void> checkTerms() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool('accepted_terms') ?? false;

    if (!accepted) {
      showTermsDialog();
    }
  }

  void showTermsDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Términos y condiciones"),
          content: const SingleChildScrollView(
            child: Text(
              "Al usar AutoMarket México aceptas nuestros términos y condiciones así como el uso responsable de la plataforma.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No acepto"),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('accepted_terms', true);

                Navigator.of(context).pop();
              },
              child: const Text("Acepto"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'AutoMarket',

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,

        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blue,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}