import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_level.dart';

class StepAgeScreen extends StatefulWidget {
  final UserProfile profile;

  const StepAgeScreen({super.key, required this.profile});

  @override
  State<StepAgeScreen> createState() => _StepAgeScreenState();
}

class _StepAgeScreenState extends State<StepAgeScreen> {
  String? selectedAge;

  final List<String> edades = [
    '0-3 meses',
    '1-2 años',
    '3-4 años',
    '4-5 años',
    '5-6 años',
    '+7 años',
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
              'Selecciona la edad de la persona',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...edades.map((edad) => ListTile(
                  title: Text(edad),
                  leading: Radio<String>(
                    value: edad,
                    groupValue: selectedAge,
                    onChanged: (value) => setState(() => selectedAge = value),
                  ),
                )),
            const Spacer(),
            ElevatedButton(
              onPressed: selectedAge == null
                  ? null
                  : () {
                      widget.profile.edad = selectedAge;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StepLevelScreen(profile: widget.profile),
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
