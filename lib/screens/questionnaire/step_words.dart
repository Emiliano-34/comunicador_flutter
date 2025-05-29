// 📄 lib/screens/questionnaire/step_words.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_understands_order.dart';

class StepWordsScreen extends StatefulWidget {
  final UserProfile profile;

  const StepWordsScreen({super.key, required this.profile});

  @override
  State<StepWordsScreen> createState() => _StepWordsScreenState();
}

class _StepWordsScreenState extends State<StepWordsScreen> {
  String? selected;

  final List<String> opciones = [
    "Palabras no pero hace sonidos",
    "Palabras no pero balbucea",
    "1-10 palabras",
    "10-20 palabras",
    "+20 palabras"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuestionario")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("¿Cuántas palabras conoce la persona?",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ...opciones.map((opcion) => ListTile(
                  title: Text(opcion),
                  leading: Radio<String>(
                    value: opcion,
                    groupValue: selected,
                    onChanged: (value) {
                      setState(() => selected = value);
                    },
                  ),
                )),
            Spacer(),
            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () {
                      widget.profile.palabrasConocidas = selected;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StepUnderstandsOrderScreen(
                            profile: widget.profile,
                          ),
                        ),
                      );
                    },
              child: Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
