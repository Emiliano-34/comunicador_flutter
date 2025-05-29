// 📄 lib/screens/questionnaire/step_understands_hearing.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_responds_to_name.dart';

class StepUnderstandsHearingScreen extends StatelessWidget {
  final UserProfile profile;

  const StepUnderstandsHearingScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuestionario")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("¿Comprende lo que escucha?",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ListTile(
              title: Text("Sí"),
              leading: Radio<bool>(
                value: true,
                groupValue: profile.comprendeLoQueEscucha,
                onChanged: (value) {
                  profile.comprendeLoQueEscucha = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepRespondsToNameScreen(profile: profile),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text("No"),
              leading: Radio<bool>(
                value: false,
                groupValue: profile.comprendeLoQueEscucha,
                onChanged: (value) {
                  profile.comprendeLoQueEscucha = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepRespondsToNameScreen(profile: profile),
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
