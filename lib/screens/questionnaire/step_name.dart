// lib/screens/questionnaire/step_name.dart

import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_age.dart';

class StepNameScreen extends StatefulWidget {
  final UserProfile profile;
  const StepNameScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _StepNameScreenState createState() => _StepNameScreenState();
}

class _StepNameScreenState extends State<StepNameScreen> {
  final _nombreCtrl = TextEditingController();

  void _next() {
    if (_nombreCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa el nombre")),
      );
      return;
    }
    widget.profile.nombre = _nombreCtrl.text.trim();
    // Navega al siguiente paso de tu flujo:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StepAgeScreen(profile: widget.profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text("¿Cómo se llama?"),
        backgroundColor: colorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: "Nombre del alumno",
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _next,
                child: const Text("Siguiente"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}