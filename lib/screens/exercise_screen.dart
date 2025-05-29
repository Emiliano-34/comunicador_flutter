import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class ExerciseScreen extends StatefulWidget {
  final List<String> assets;
  final String question;
  final int correctIndex;
  final String title; // añadimos título para lógica especial

  const ExerciseScreen({
    super.key,
    required this.assets,
    required this.question,
    required this.correctIndex,
    this.title = '',
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TtsService _tts = TtsService();
  String feedback = '';
  String? textAnswer;

  // ✨ Para Colores: definimos 3 rondas
  final _colorRounds = [
    {
      'question': '¿Cuál es el cuadrado?',
      'assets': [
        'assets/images/triangle.png',
        'assets/images/circle.png',
        'assets/images/square.png',
      ],
      'correct': 2
    },
    {
      'question': '¿Cuál es el círculo?',
      'assets': [
        'assets/images/square.png',
        'assets/images/circle.png',
        'assets/images/triangle.png',
      ],
      'correct': 1
    },
    {
      'question': '¿Cuál es el triángulo?',
      'assets': [
        'assets/images/circle.png',
        'assets/images/triangle.png',
        'assets/images/square.png',
      ],
      'correct': 1
    },
  ];
  int _currentRound = 0;

  @override
  void initState() {
    super.initState();
    _tts.speak(widget.question);
  }

  void _submitText() {
    if ((textAnswer ?? '').trim().isEmpty) return;
    _tts.speak('Te llamas ${textAnswer!.trim()}');
    setState(() {
      feedback = '¡Genial, $textAnswer!';
    });
  }

  void _selectImage(int index) {
    final correctIndex = (widget.title == 'Colores')
        ? _colorRounds[_currentRound]['correct'] as int
        : widget.correctIndex;

    if (index == correctIndex) {
      _tts.speak('¡Muy bien!');
      setState(() {
        feedback = '✅ Correcto';
      });

      // Si es Colores, avanzamos ronda
      if (widget.title == 'Colores' && _currentRound < _colorRounds.length - 1) {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _currentRound++;
            feedback = '';
          });
          final next = _colorRounds[_currentRound];
          _tts.speak(next['question'] as String);
        });
      }
    } else {
      _tts.speak('Intenta otra vez');
      setState(() {
        feedback = '❌ Incorrecto';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si este es el ejercicio Colores, tomamos datos de la ronda actual:
    final isColor = widget.title == 'Colores';
    final question = isColor
        ? _colorRounds[_currentRound]['question'] as String
        : widget.question;
    final assets = isColor
        ? List<String>.from(_colorRounds[_currentRound]['assets'] as List)
        : widget.assets;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(question, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),

            if (widget.assets.isEmpty) ...[
              // Ejercicio de texto
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Escribe aquí tu nombre',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => textAnswer = v,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitText,
                child: const Text('Enviar'),
              ),
            ] else ...[
              // Ejercicio de imágenes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  assets.length,
                  (i) => GestureDetector(
                    onTap: () => _selectImage(i),
                    child: Image.asset(assets[i], width: 100),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
            Text(feedback, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
