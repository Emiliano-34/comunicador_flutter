// lib/screens/exercise_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/exercise.dart';
import '../services/tts_service.dart';

class ExerciseScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final int initialExerciseIndex;
  final String profileId;

  const ExerciseScreen({
    Key? key,
    required this.exercises,
    this.initialExerciseIndex = 0,
    required this.profileId,
  }) : super(key: key);

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late int _exerciseIndex;
  int _roundIndex = 0;
  bool _answered = false;
  String _userInput = '';
  final TtsService _tts = TtsService();

  @override
  void initState() {
    super.initState();
    _exerciseIndex = widget.initialExerciseIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrentQuestion());
  }

  void _speakCurrentQuestion() {
    final question = widget.exercises[_exerciseIndex].rounds[_roundIndex].question;
    _tts.speak(question);
  }

  Future<void> _next() async {
    final rounds = widget.exercises[_exerciseIndex].rounds;
    final isLast = _roundIndex == rounds.length - 1;

    if (isLast) {
      final passed = _answered;
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('perfiles')
          .doc(widget.profileId)
          .collection('puntuaciones')
          .add({
        'tipo': 'ejercicio_${widget.exercises[_exerciseIndex].title}',
        'timestamp': FieldValue.serverTimestamp(),
        'passed': passed,
      });
    }

    if (_roundIndex < rounds.length - 1) {
      setState(() {
        _roundIndex++;
        _answered = false;
        _userInput = '';
      });
      _speakCurrentQuestion();
    }
  }

  void _previous() {
    if (_roundIndex > 0) {
      setState(() {
        _roundIndex--;
        _answered = false;
        _userInput = '';
      });
      _speakCurrentQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final exercise = widget.exercises[_exerciseIndex];
    final round = exercise.rounds[_roundIndex];
    final isWritten = round.expectedAnswer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title),
        centerTitle: true,
        backgroundColor: primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: _speakCurrentQuestion,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_roundIndex + 1) / exercise.rounds.length,
              color: primary,
              backgroundColor: primary.withOpacity(0.2),
              minHeight: 6,
            ),
            const SizedBox(height: 24),
            Text(
              round.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (round.options.isNotEmpty) ...[
              for (var i = 0; i < round.options.length; i++)
                ListTile(
                  title: Text(round.options[i]),
                  leading: Radio<int>(
                    value: i,
                    groupValue: _answered && round.correctIndex == i ? i : null,
                    onChanged: (val) {
                      setState(() {
                        _answered = val == round.correctIndex;
                      });
                    },
                  ),
                ),
            ] else if (isWritten) ...[
              TextField(
                decoration: const InputDecoration(labelText: 'Tu respuesta'),
                onChanged: (val) => _userInput = val,
              ),
              ElevatedButton(
                onPressed: () {
                  final correct = round.expectedAnswer?.toLowerCase() == _userInput.toLowerCase();
                  setState(() => _answered = correct);
                },
                child: const Text('Verificar'),
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: _previous, child: const Text('Anterior')),
                ElevatedButton(onPressed: _next, child: const Text('Siguiente')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
