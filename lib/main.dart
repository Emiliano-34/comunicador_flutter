// lib/main.dart
import 'package:flutter/material.dart';
import 'models/user_profile.dart';
import 'screens/questionnaire/step_age.dart';

void main() {
  runApp(const ComunicadorApp());
}

class ComunicadorApp extends StatelessWidget {
  const ComunicadorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comunicador',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StepAgeScreen(profile: UserProfile()),
      debugShowCheckedModeBanner: false,
    );
  }
}
