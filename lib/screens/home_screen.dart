import 'package:flutter/material.dart';
import 'questionnaire/step_age.dart';
import '../models/user_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required UserProfile profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Comunicador')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StepAgeScreen(profile: UserProfile()),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: const StadiumBorder(),
          ),
          child: const Text('Iniciar cuestionario', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
