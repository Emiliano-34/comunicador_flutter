import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../utils/exercise_generator.dart';
import 'trace_name_screen.dart';
import 'exercise_screen.dart';
import 'face_assembly_screen.dart';

class ExercisesSelectionScreen extends StatelessWidget {
  final UserProfile profile;
  const ExercisesSelectionScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;

    // Genera todos los ejercicios para este perfil
    final allExercises = generateExercises(profile);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un ejercicio'),
        backgroundColor: colorPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 1) Trazar el nombre ────────────────────────────────
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.edit, color: colorPrimary),
              title: const Text('Trazar mi nombre'),
              subtitle: const Text('Dibuja tu nombre con el dedo'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TraceNameScreen(name: profile.nombre ?? ''),
                ),
              ),
            ),
          ),

          // ── 2) Armar una cara ───────────────────────────────────
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.face, color: colorPrimary),
              title: const Text('Armar una cara'),
              subtitle: const Text('Arrastra ojos, nariz y boca'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FaceAssemblyScreen(profile: profile),
                ),
              ),
            ),
          ),

          // ── 3) Ejercicios de selección de imágenes ────────────────
          ...allExercises.map((exercise) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.image, color: colorPrimary),
                  title: Text(exercise.title),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(
                        exercises: [exercise],
                        initialExerciseIndex: 0,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}