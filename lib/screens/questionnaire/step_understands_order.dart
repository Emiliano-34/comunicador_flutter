// 📄 lib/screens/questionnaire/step_understands_order.dart
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_understands_time.dart';

class StepUnderstandsOrderScreen extends StatelessWidget {
  final UserProfile profile;

  const StepUnderstandsOrderScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuestionario")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("¿Comprende palabras de orden como primero, siguiente y último?",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ListTile(
              title: Text("Sí"),
              leading: Radio<bool>(
                value: true,
                groupValue: profile.comprendeOrden,
                onChanged: (value) {
                  profile.comprendeOrden = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepUnderstandsTimeScreen(profile: profile),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text("No"),
              leading: Radio<bool>(
                value: false,
                groupValue: profile.comprendeOrden,
                onChanged: (value) {
                  profile.comprendeOrden = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepUnderstandsTimeScreen(profile: profile),
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

