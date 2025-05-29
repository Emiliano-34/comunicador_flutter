// 📄 lib/screens/questionnaire/step_follows_instructions.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_understands_hearing.dart';

class StepFollowsInstructionsScreen extends StatelessWidget {
  final UserProfile profile;

  const StepFollowsInstructionsScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuestionario")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("¿Sigue instrucciones como 'lávate los dientes'?",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ListTile(
              title: Text("Sí"),
              leading: Radio<bool>(
                value: true,
                groupValue: profile.sigueInstrucciones,
                onChanged: (value) {
                  profile.sigueInstrucciones = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepUnderstandsHearingScreen(profile: profile),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text("No"),
              leading: Radio<bool>(
                value: false,
                groupValue: profile.sigueInstrucciones,
                onChanged: (value) {
                  profile.sigueInstrucciones = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepUnderstandsHearingScreen(profile: profile),
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
