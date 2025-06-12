import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_responds_to_name.dart';

class StepFollowsInstructionsScreen extends StatefulWidget {
  final UserProfile profile;
  const StepFollowsInstructionsScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _StepFollowsInstructionsScreenState createState() => _StepFollowsInstructionsScreenState();
}

class _StepFollowsInstructionsScreenState extends State<StepFollowsInstructionsScreen> {
  int _selectedIndex = -1;
  final List<String> _opciones = ['Sí', 'No'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.blue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Progreso
            LinearProgressIndicator(
              value: 8 /  8,
              color: Colors.blue,
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 24),
            const Text(
              'INSTRUCCIONES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/instructions_icon.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),
            const Text(
              '¿Sigue instrucciones como “Lávate las manos”?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Por ejemplo: “Recoge tus juguetes”',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Opciones
            Expanded(
              child: ListView.builder(
                itemCount: _opciones.length,
                itemBuilder: (context, i) {
                  final selected = i == _selectedIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: selected ? Colors.blue.shade50 : Colors.white,
                        border: Border.all(
                            color: selected ? Colors.blue : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _opciones[i],
                        style: TextStyle(
                          fontSize: 18,
                          color: selected ? Colors.blue : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botón Continuar
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedIndex < 0
                    ? null
                    : () {
                        widget.profile.sigueInstrucciones = (_selectedIndex == 0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StepRespondsToNameScreen(
                              profile: widget.profile,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Continuar', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}