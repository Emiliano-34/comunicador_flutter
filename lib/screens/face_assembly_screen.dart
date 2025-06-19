// lib/screens/face_assembly_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_profile.dart';

class FaceAssemblyScreen extends StatefulWidget {
  final UserProfile profile;
  final String profileId;  // ← Nuevo parámetro
  const FaceAssemblyScreen({
    Key? key,
    required this.profile,
    required this.profileId,
  }) : super(key: key);

  @override
  FaceAssemblyScreenState createState() => FaceAssemblyScreenState();
}

class FaceAssemblyScreenState extends State<FaceAssemblyScreen> {
  // Controla qué partes ya se colocaron
  final Map<String, bool> _placed = {
    'eyes': false,
    'nose': false,
    'mouth': false,
  };

  // Indica si el usuario está arrastrando sobre un target
  final Map<String, bool> _hovering = {
    'eyes': false,
    'nose': false,
    'mouth': false,
  };

  // Lista de emojis que usaremos para los Draggables
  final Map<String, String> _emojis = {
    'eyes': '👀',
    'nose': '👃',
    'mouth': '👄',
  };

  String? _evaluationResult;
  int _attempts = 0;

  // Reinicia el ejercicio
  void _clear() {
    setState(() {
      _placed.updateAll((key, _) => false);
      _hovering.updateAll((key, _) => false);
      _evaluationResult = null;
      _attempts = 0;
    });
  }

  // Evalúa si todas las piezas están colocadas y guarda el resultado
  Future<void> _evaluate() async {
    setState(() {
      _attempts++;
    });
    final complete = _placed.values.every((v) => v);

    // Guardar resultado en Firestore
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('perfiles')
        .doc(widget.profileId)
        .collection('puntuaciones')
        .add({
      'tipo': 'armar_cara',
      'timestamp': FieldValue.serverTimestamp(),
      'passed': complete,
      'intentos': _attempts,
    });

    setState(() {
      if (complete) {
        _evaluationResult = '¡Bien hecho! Cara completa en $_attempts intento(s).';
      } else {
        final missing = _placed.entries
            .where((e) => !e.value)
            .map((e) => e.key)
            .join(', ');
        _evaluationResult = 'Faltan piezas: $missing';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Armar una cara'),
        backgroundColor: colorPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Reiniciar',
            onPressed: _clear,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // ── Canvas de cara ─────────────────────────────────────────
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Silueta de cabeza
                  Container(
                    width: 240,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),

                  // Ojos
                  _buildTarget(
                    keyName: 'eyes',
                    top: 90,
                    left: 100,
                  ),

                  // Nariz
                  _buildTarget(
                    keyName: 'nose',
                    top: 140,
                  ),

                  // Boca
                  _buildTarget(
                    keyName: 'mouth',
                    bottom: 90,
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 1),

          // ── Palette de partes para arrastrar ────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _emojis.entries.map((entry) {
                final part = entry.key;
                final emoji = entry.value;
                if (_placed[part]!) return const SizedBox(width: 48);
                return Draggable<String>(
                  data: part,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Text(emoji, style: const TextStyle(fontSize: 36)),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: Text(emoji, style: const TextStyle(fontSize: 36)),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 36)),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // ── Botón Evaluar ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _placed.values.every((v) => v) ? _evaluate : null,
                child: const Text('Evaluar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Mensaje de resultado ───────────────────────────────────
          if (_evaluationResult != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: Text(
                _evaluationResult!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _evaluationResult!.startsWith('¡Bien') ? Colors.green : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Helper que crea un DragTarget para cada parte de la cara
  Widget _buildTarget({
    required String keyName,
    double? top,
    double? left,
    double? bottom,
  }) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      child: Builder(builder: (context) {
        final cp = Theme.of(context).colorScheme.primary;
        return DragTarget<String>(
          onWillAcceptWithDetails: (details) {
            setState(() => _hovering[keyName] = true);
            return details.data == keyName;
          },
          onLeave: (_) {
            setState(() => _hovering[keyName] = false);
          },
          onAcceptWithDetails: (details) {
            if (details.data == keyName) {
              setState(() => _placed[keyName] = true);
            }
            setState(() => _hovering[keyName] = false);
          },
          builder: (context, candidateData, rejectedData) {
            final placed = _placed[keyName]!;
            final hover = _hovering[keyName]!;
            return Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: placed
                    ? Colors.transparent
                    : (hover ? cp.withOpacity(0.3) : Colors.white),
                border: Border.all(
                  color: placed
                      ? cp
                      : (hover ? cp : Colors.grey),
                  width: hover || placed ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                placed ? _emojis[keyName]! : '',
                style: const TextStyle(fontSize: 36),
              ),
            );
          },
        );
      }),
    );
  }
}
