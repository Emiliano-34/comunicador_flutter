// 📄 lib/screens/questionnaire/step_can_say_name.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_follows_instructions.dart';

class StepCanSayNameScreen extends StatelessWidget {
  final UserProfile profile;

  const StepCanSayNameScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuestionario")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("¿Puede decir su nombre y apellido?",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ListTile(
              title: Text("Sí"),
              leading: Radio<bool>(
                value: true,
                groupValue: profile.puedeDecirNombre,
                onChanged: (value) {
                  profile.puedeDecirNombre = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepFollowsInstructionsScreen(profile: profile),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text("No"),
              leading: Radio<bool>(
                value: false,
                groupValue: profile.puedeDecirNombre,
                onChanged: (value) {
                  profile.puedeDecirNombre = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepFollowsInstructionsScreen(profile: profile),
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

