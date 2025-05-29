import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_words.dart';

class StepLevelScreen extends StatefulWidget {
  final UserProfile profile;

  const StepLevelScreen({super.key, required this.profile});

  @override
  State<StepLevelScreen> createState() => _StepLevelScreenState();
}

class _StepLevelScreenState extends State<StepLevelScreen> {
  String? selectedLevel;

  final List<String> niveles = [
    'No verbal',
    'No verbal pero puede decir sí/no',
    'No puede hablar pero conoce las palabras',
    'Habla pero no todos lo entienden',
    'Verbal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuestionario')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Selecciona el nivel de habla',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...niveles.map((nivel) => ListTile(
                  title: Text(nivel),
                  leading: Radio<String>(
                    value: nivel,
                    groupValue: selectedLevel,
                    onChanged: (value) => setState(() => selectedLevel = value),
                  ),
                )),
            const Spacer(),
            ElevatedButton(
              onPressed: selectedLevel == null
                  ? null
                  : () {
                      widget.profile.nivelHabla = selectedLevel;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StepWordsScreen(profile: widget.profile),
                        ),
                      );
                    },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
