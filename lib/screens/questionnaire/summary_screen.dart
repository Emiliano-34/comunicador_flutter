// lib/screens/questionnaire/summary_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_profile.dart';
import '../exercises_selection_screen.dart';

class SummaryScreen extends StatefulWidget {
  final UserProfile profile;
  const SummaryScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _isSaving = false;

  Future<void> _saveProfileAndProceed() async {
    setState(() => _isSaving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("Usuario no autenticado");

      // Mapa con todos los campos de tu modelo
      final data = {
        'nombre'               : widget.profile.nombre,
        'edad'                 : widget.profile.edad,
        'nivelHabla'           : widget.profile.nivelHabla,
        'palabrasConocidas'    : widget.profile.palabrasConocidas,
        'comprendeOrden'       : widget.profile.comprendeOrden,
        'comprendeTiempo'      : widget.profile.comprendeTiempo,
        'puedeDecirNombre'     : widget.profile.puedeDecirNombre,
        'sigueInstrucciones'   : widget.profile.sigueInstrucciones,
        'comprendeLoQueEscucha': widget.profile.comprendeLoQueEscucha,
        'respondeAlNombre'     : widget.profile.respondeAlNombre,
        'fechaCreacion'        : FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('perfiles')
          .add(data);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ExercisesSelectionScreen(profile: widget.profile),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar perfil: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

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
                    icon: Icons.person,
                    title: 'Nombre',
                    value: widget.profile.nombre ?? 'No ingresado',
                  ),
                  _buildCard(
                    icon: Icons.cake,
                    title: 'Edad',
                    value: widget.profile.edad ?? 'No seleccionada',
                  ),
                  _buildCard(
                    icon: Icons.record_voice_over,
                    title: 'Nivel de habla',
                    value: widget.profile.nivelHabla ?? 'No seleccionado',
                  ),
                  _buildCard(
                    icon: Icons.library_books,
                    title: 'Palabras conocidas',
                    value: widget.profile.palabrasConocidas ?? 'No seleccionadas',
                  ),
                  _buildCard(
                    icon: Icons.list_alt,
                    title: 'Comprende órdenes',
                    value: widget.profile.comprendeOrden == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.access_time,
                    title: 'Comprende el tiempo',
                    value: widget.profile.comprendeTiempo == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.checklist,
                    title: 'Sigue instrucciones',
                    value: widget.profile.sigueInstrucciones == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.hearing,
                    title: 'Comprende lo que escucha',
                    value: widget.profile.comprendeLoQueEscucha == true ? 'Sí' : 'No',
                  ),
                  _buildCard(
                    icon: Icons.alarm_on,
                    title: 'Responde al nombre',
                    value: widget.profile.respondeAlNombre == true ? 'Sí' : 'No',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.fitness_center, size: 24),
                label: Text(
                  _isSaving ? 'Guardando...' : 'Ver ejercicios',
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: _isSaving ? null : _saveProfileAndProceed,
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