// lib/screens/trace_name_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TraceNameScreen extends StatefulWidget {
  final String name;
  const TraceNameScreen({Key? key, required this.name}) : super(key: key);

  @override
  TraceNameScreenState createState() => TraceNameScreenState();
}

class TraceNameScreenState extends State<TraceNameScreen> {
  final List<Offset?> _points = [];
  bool _evaluating = false;
  String? _result;

  // Agrega un método para borrar todo
  void _clear() {
    setState(() {
      _points.clear();
      _result = null;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final p = box.globalToLocal(details.globalPosition);
    setState(() => _points.add(p));
  }

  void _onPanEnd(DragEndDetails _) {
    _points.add(null); // separa trazos discontinuos
  }

  void _evaluate() {
    setState(() {
      _evaluating = true;
      _result = null;
    });

    // 1) Calcula la longitud total del trazo
    double totalLength = 0;
    for (var i = 0; i < _points.length - 1; i++) {
      final p = _points[i];
      final n = _points[i + 1];
      if (p != null && n != null) {
        totalLength += (n - p).distance;
      }
    }

    // 2) Determina un umbral dinámico:
    //    aproximamos que cada letra necesita ~1.2 veces el tamaño de fuente en px.
    const double fontSize = 72.0;
    final double threshold = widget.name.length * fontSize * 1.2;

    // 3) Comprueba si supera el umbral
    final ok = totalLength >= threshold;
    setState(() {
      _evaluating = false;
      _result = ok
          ? "¡Bien hecho! Longitud ${totalLength.toStringAsFixed(0)}px ≥ umbral ${threshold.toStringAsFixed(0)}px"
          : "Intenta de nuevo: ${totalLength.toStringAsFixed(0)}px < umbral ${threshold.toStringAsFixed(0)}px";
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Traza tu nombre"),
        backgroundColor: colorPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Borrar trazo",
            onPressed: _clear,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  // Plantilla de nombre en gris claro
                  Center(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 72,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Canvas de dibujo en tiempo real
                  GestureDetector(
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _DrawingPainter(points: _points),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botón de evaluación
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (_evaluating || _points.isEmpty) ? null : _evaluate,
                child: _evaluating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Evaluar", style: TextStyle(fontSize: 18)),
              ),
            ),
          ),

          // Mensaje de resultado
          if (_result != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                _result!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _result!.startsWith("¡Bien") ? Colors.green : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  const _DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < points.length - 1; i++) {
      final p = points[i];
      final n = points[i + 1];
      if (p != null && n != null) {
        canvas.drawLine(p, n, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter old) =>
      old.points != points;
}