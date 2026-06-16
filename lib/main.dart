import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;

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
      home: Dashboard(),
    );
  }
}
