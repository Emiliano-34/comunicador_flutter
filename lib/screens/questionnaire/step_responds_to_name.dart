// 📄 lib/screens/questionnaire/step_responds_to_name.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'summary_screen.dart';

class StepRespondsToNameScreen extends StatelessWidget {
  final UserProfile profile;

  const StepRespondsToNameScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuestionario")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("¿Responde al escuchar su nombre?",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ListTile(
              title: Text("Sí"),
              leading: Radio<bool>(
                value: true,
                groupValue: profile.respondeAlNombre,
                onChanged: (value) {
                  profile.respondeAlNombre = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(profile: profile),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text("No"),
              leading: Radio<bool>(
                value: false,
                groupValue: profile.respondeAlNombre,
                onChanged: (value) {
                  profile.respondeAlNombre = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(profile: profile),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

