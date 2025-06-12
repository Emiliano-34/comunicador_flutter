// 📄 lib/screens/questionnaire/summary_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../exercises_selection_screen.dart';

class SummaryScreen extends StatelessWidget {
  final UserProfile profile;
  const SummaryScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del perfil'),
        backgroundColor: colorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '¡Todo listo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Este es el resumen de tu cuestionario:',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCard(
                    icon: Icons.cake,
                    title: 'Edad',
                    value: profile.edad ?? 'No seleccionada',
                  ),
                  _buildCard(
                    icon: Icons.record_voice_over,
                    title: 'Nivel de habla',
                    value: profile.nivelHabla ?? 'No seleccionado',
                  ),
                  _buildCard(
                    icon: Icons.library_books,
                    title: 'Palabras conocidas',
                    value: profile.palabrasConocidas ?? 'No seleccionadas',
                  ),
                  _buildCard(
                    icon: Icons.list_alt,
                    title: 'Comprende órdenes',
                    value: profile.comprendeOrden == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.access_time,
                    title: 'Comprende el tiempo',
                    value: profile.comprendeTiempo == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.person,
                    title: 'Dice su nombre',
                    value: profile.puedeDecirNombre == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.checklist,
                    title: 'Sigue instrucciones',
                    value: profile.sigueInstrucciones == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.hearing,
                    title: 'Comprende lo que escucha',
                    value: profile.comprendeLoQueEscucha == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.alarm_on,
                    title: 'Responde al nombre',
                    value: profile.respondeAlNombre == true ? 'Sí' : 'No',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.fitness_center, size: 24),
                label: const Text('Ver ejercicios', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExercisesSelectionScreen(profile: profile),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
