import 'package:flutter/material.dart';
import 'exercise_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(title: const Text('Comunicador')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExerciseScreen(
                  assets: [
                    'assets/images/triangle.png',
                    'assets/images/circle.png',
                    'assets/images/square.png',
                  ],
                  question: '¿Cuál es el cuadrado?',
                  correctIndex: 2,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            "Iniciar Ejercicio",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
