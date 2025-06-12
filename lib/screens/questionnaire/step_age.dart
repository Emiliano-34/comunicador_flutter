import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_level.dart';

class StepAgeScreen extends StatefulWidget {
  final UserProfile profile;
  const StepAgeScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _StepAgeScreenState createState() => _StepAgeScreenState();
}

class _StepAgeScreenState extends State<StepAgeScreen> {
  int _selectedIndex = -1;
  final List<String> _edades = [
    '0–3 meses',
    '4–6 meses',
    '7–12 meses',
    '1–2 años',
    '3–4 años',
    '5+ años',
  ];

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
            // 1) Barra de progreso
            LinearProgressIndicator(
              value: 1 / 7,
              color: Colors.blue,
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 24),

            // 2) Título de sección
            const Text(
              'PRELIMINARES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // 3) Ilustración
            Image.asset(
              'assets/images/age_icon.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),

            // 4) Título + subtítulo
            const Text(
              'Selecciona la edad del niño',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Esto nos ayudara a personalizar la aplicación.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // 5) Opciones
            Expanded(
              child: ListView.builder(
                itemCount: _edades.length,
                itemBuilder: (context, i) {
                  final selected = i == _selectedIndex;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedIndex = i;
                      widget.profile.edad = _edades[i];
                    }),
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
                        _edades[i],
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

            // 6) Botón Continue
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedIndex < 0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                StepLevelScreen(profile: widget.profile),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
