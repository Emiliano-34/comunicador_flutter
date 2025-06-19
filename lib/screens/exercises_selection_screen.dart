// lib/screens/exercises_selection_screen.dart

import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../utils/exercise_generator.dart';
import 'trace_name_screen.dart';
import 'face_assembly_screen.dart';
import 'exercise_screen.dart';
import 'progress_screen.dart';

class ExercisesSelectionScreen extends StatelessWidget {
  final UserProfile profile;
  final String profileId;  // ← Agregado

  const ExercisesSelectionScreen({
    Key? key,
    required this.profile,
    required this.profileId,  // ← Requerido
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final allExercises = generateExercises(profile);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Selecciona un ejercicio'),
        centerTitle: true,
        backgroundColor: colorPrimary,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: 'Ver progreso',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProgressScreen(profileId: profileId),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ► Encabezado de bienvenida
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                '¡Hola, ${profile.nombre ?? 'Usuario'}!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                ),
              ),
            ),

            // ► Listado con separadores
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: allExercises.length + 2,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  if (idx == 0) {
                    // 1) Trazar el nombre
                    return _buildCard(
                      icon: Icons.edit,
                      title: 'Trazar mi nombre',
                      subtitle: 'Dibuja tu nombre con el dedo',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TraceNameScreen(
                            name: profile.nombre ?? '',
                            profileId: profileId,  // ← Pasamos profileId
                          ),
                        ),
                      ),
                      colorPrimary: colorPrimary,
                    );
                  } else if (idx == 1) {
                    // 2) Armar una cara
                    return _buildCard(
                      icon: Icons.face,
                      title: 'Armar una cara',
                      subtitle: 'Arrastra ojos, nariz y boca',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FaceAssemblyScreen(
                            profile: profile,
                            profileId: profileId,  // ← Pasamos profileId
                          ),
                        ),
                      ),
                      colorPrimary: colorPrimary,
                    );
                  } else {
                    // 3) Ejercicios generados automáticamente
                    final exercise = allExercises[idx - 2];
                    return _buildCard(
                      icon: Icons.image,
                      titleWidget: Text(
                        exercise.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseScreen(
                            exercises: [exercise],
                            initialExerciseIndex: 0,
                            profileId: profileId,  // ← Pasamos profileId
                          ),
                        ),
                      ),
                      colorPrimary: colorPrimary,
                      hasArrow: true,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    String? title,
    Widget? titleWidget,
    String? subtitle,
    required VoidCallback onTap,
    required Color colorPrimary,
    bool hasArrow = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        leading: Icon(icon, size: 28, color: colorPrimary),
        title: titleWidget ??
            Text(title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: hasArrow ? const Icon(Icons.arrow_forward_ios, size: 20) : null,
        onTap: onTap,
      ),
    );
  }
}
