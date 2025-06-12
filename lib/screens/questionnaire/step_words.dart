import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'step_understands_order.dart';

class StepWordsScreen extends StatefulWidget {
  final UserProfile profile;
  const StepWordsScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _StepWordsScreenState createState() => _StepWordsScreenState();
}

class _StepWordsScreenState extends State<StepWordsScreen> {
  int _selectedIndex = -1;
  final List<String> _opciones = [
    'Palabras no pero murmulla y ríe',
    'Palabras no pero balbucea',
    '1–5 palabras',
    '5–10 palabras',
    '+10 palabras',
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
            // Barra de progreso: tercer paso de 7
            LinearProgressIndicator(
              value: 3 / 7,
              color: Colors.blue,
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 24),

            // Etiqueta
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

            // Icono ilustrativo
            Image.asset(
              'assets/images/words_icon.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),

            // Título y subtítulo
            const Text(
              '¿Cuántas palabras puede hablar el niño?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona la descripción más acertada.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Opciones en tarjetas
            Expanded(
              child: ListView.builder(
                itemCount: _opciones.length,
                itemBuilder: (context, i) {
                  final selected = i == _selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                        widget.profile.palabrasConocidas = _opciones[i];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: selected ? Colors.blue.shade50 : Colors.white,
                        border: Border.all(
                          color: selected ? Colors.blue : Colors.grey.shade300,
                          width: selected ? 2 : 1,
                        ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StepUnderstandsOrderScreen(
                              profile: widget.profile,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
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
