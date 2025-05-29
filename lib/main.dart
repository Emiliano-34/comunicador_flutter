// 📄 lib/main.dart
import 'package:flutter/material.dart';
import 'models/user_profile.dart';
import 'screens/questionnaire/step_age.dart';

void main() {
  runApp(const ComunicadorApp());
}

class ComunicadorApp extends StatelessWidget {
  const ComunicadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comunicador',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const InicioCuestionario(),
    );
  }
}

class InicioCuestionario extends StatelessWidget {
  const InicioCuestionario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(title: const Text("Inicio del cuestionario")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StepAgeScreen(profile: UserProfile()),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            "Iniciar cuestionario",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
