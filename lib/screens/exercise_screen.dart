import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/tts_service.dart';

class ExerciseScreen extends StatefulWidget {
  /// Lista completa de ejercicios (cada uno con sus rondas).
  final List<Exercise> exercises;

  /// Índice del ejercicio inicial dentro de esa lista.
  final int initialExerciseIndex;

  const ExerciseScreen({
    Key? key,
    required this.exercises,
    this.initialExerciseIndex = 0,
  }) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late int _exerciseIndex;
  int _roundIndex = 0;
  bool _answered = false;
  final TtsService _tts = TtsService();
  String _userInput = '';

  @override
  void initState() {
    super.initState();
    _exerciseIndex = widget.initialExerciseIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrentQuestion());
  }

  void _speakCurrentQuestion() {
    final round = widget.exercises[_exerciseIndex].rounds[_roundIndex];
    _tts.speak(round.question);
  }

  void _next() {
    final rounds = widget.exercises[_exerciseIndex].rounds;
    if (_roundIndex < rounds.length - 1) {
      setState(() {
        _roundIndex++;
        _answered = false;
        _userInput = '';
      });
    } else {
      setState(() {
        _roundIndex = 0;
        _exerciseIndex = (_exerciseIndex + 1) % widget.exercises.length;
        _answered = false;
        _userInput = '';
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrentQuestion());
  }

  void _handleAnswer(int selected) {
    if (_answered) return;
    setState(() => _answered = true);

    final round = widget.exercises[_exerciseIndex].rounds[_roundIndex];
    final isCorrect = selected == round.correctIndex;
    final msg = isCorrect ? '¡Correcto!' : 'Intenta de nuevo';
    final color = isCorrect ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(milliseconds: 800),
      ),
    );
    _tts.speak(msg);

    Future.delayed(const Duration(milliseconds: 900), _next);
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercises[_exerciseIndex];
    final round = exercise.rounds[_roundIndex];
    final primary = Theme.of(context).colorScheme.primary;

    final isPlana = round.expectedAnswer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title),
        centerTitle: true,
        backgroundColor: primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: _speakCurrentQuestion,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Progreso
            LinearProgressIndicator(
              value: (_roundIndex + 1) / exercise.rounds.length,
              color: primary,
              backgroundColor: primary.withOpacity(0.2),
              minHeight: 6,
            ),
            const SizedBox(height: 24),

            // Pregunta
            Text(
              round.question,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Si es tipo plana, mostrar input de texto
            if (isPlana)
              Column(
                children: [
                  TextField(
                    onChanged: (value) => _userInput = value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tu respuesta',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _answered
                        ? null
                        : () {
                            final isCorrect = _userInput.trim().toLowerCase() ==
                                round.expectedAnswer!.toLowerCase();

                            setState(() => _answered = true);

                            final msg = isCorrect ? '¡Correcto!' : 'Intenta de nuevo';
                            final color = isCorrect ? Colors.green : Colors.red;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(msg),
                                backgroundColor: color,
                                duration: const Duration(milliseconds: 800),
                              ),
                            );
                            _tts.speak(msg);

                            Future.delayed(const Duration(milliseconds: 900), _next);
                          },
                    child: const Text('Responder'),
                  ),
                ],
              )
            else
              Expanded(
                child: GridView.builder(
                  itemCount: round.assets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, i) {
                    final bgColor = !_answered
                        ? Colors.white
                        : (i == round.correctIndex
                            ? Colors.green.shade100
                            : Colors.white);

                    return GestureDetector(
                      onTap: () => _handleAnswer(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(color: primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                round.assets[i],
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              round.options[i],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
