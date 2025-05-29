// 📄 lib/screens/questionnaire/summary_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../exercises_selection_screen.dart';

class SummaryScreen extends StatelessWidget {
  final UserProfile profile;
  const SummaryScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen del perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perfil generado:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Edad: ${profile.edad}'),
            Text('Nivel de habla: ${profile.nivelHabla}'),
            Text('Palabras conocidas: ${profile.palabrasConocidas}'),
            Text('Comprende orden: ${profile.comprendeOrden}'),
            Text('Comprende tiempo: ${profile.comprendeTiempo}'),
            Text('Puede decir su nombre: ${profile.puedeDecirNombre}'),
            Text('Sigue instrucciones: ${profile.sigueInstrucciones}'),
            Text('Comprende lo que escucha: ${profile.comprendeLoQueEscucha}'),
            Text('Responde al nombre: ${profile.respondeAlNombre}'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExercisesSelectionScreen(profile: profile),
                    ),
                  );
                },
                child: const Text('Ver ejercicios personalizados'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
