import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../utils/exercise_generator.dart';
import 'exercise_screen.dart';

class ExercisesSelectionScreen extends StatelessWidget {
  final UserProfile profile;
  const ExercisesSelectionScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final exercises = generateExercises(profile);

    return Scaffold(
      appBar: AppBar(title: const Text('Elige un ejercicio')),
      body: ListView.separated(
        itemCount: exercises.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final e = exercises[i];
          return ListTile(
            leading: const Icon(Icons.play_circle_fill, color: Colors.indigo),
            title: Text(
              e.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(e.question),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseScreen(
                    assets: e.assets,
                    question: e.question,
                    correctIndex: e.correctIndex,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
