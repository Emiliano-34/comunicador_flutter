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

      // Guardamos perfil y obtenemos su ID
      final docRef = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('perfiles')
        .add(data);

      // Navegamos pasando profileId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ExercisesSelectionScreen(
            profile: widget.profile,
            profileId: docRef.id,  // ← aquí
          ),
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
            const Text('¡Todo listo!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCard(Icons.person, 'Nombre', widget.profile.nombre ?? 'No ingresado'),
                  _buildCard(Icons.cake, 'Edad', widget.profile.edad ?? 'No seleccionada'),
                  _buildCard(Icons.record_voice_over, 'Nivel de habla', widget.profile.nivelHabla ?? 'No seleccionado'),
                  _buildCard(Icons.library_books, 'Palabras conocidas', widget.profile.palabrasConocidas ?? 'No seleccionadas'),
                  _buildCard(Icons.list_alt, 'Comprende órdenes', widget.profile.comprendeOrden == true ? 'Sí' : 'No'),
                  _buildCard(Icons.access_time, 'Comprende el tiempo', widget.profile.comprendeTiempo == true ? 'Sí' : 'No'),
                  _buildCard(Icons.checklist, 'Sigue instrucciones', widget.profile.sigueInstrucciones == true ? 'Sí' : 'No'),
                  _buildCard(Icons.hearing, 'Comprende lo que escucha', widget.profile.comprendeLoQueEscucha == true ? 'Sí' : 'No'),
                  _buildCard(Icons.alarm_on, 'Responde al nombre', widget.profile.respondeAlNombre == true ? 'Sí' : 'No'),
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
                        width: 24, height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.fitness_center, size: 24),
                label: Text(_isSaving ? 'Guardando...' : 'Ver ejercicios', style: const TextStyle(fontSize: 18)),
                onPressed: _isSaving ? null : _saveProfileAndProceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String value) {
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
