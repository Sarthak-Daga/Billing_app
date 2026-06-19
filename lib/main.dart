import 'package:billing_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:billing_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['PROJECT_URL']!,
    anonKey: dotenv.env['PUBLISHABLE_KEY']!,
  );
  print("Supabase Connected!");

  runApp(const MahadevTelecoms());
}

class MahadevTelecoms extends StatelessWidget {
  const MahadevTelecoms({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MahadevTelecoms",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}
