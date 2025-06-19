import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TraceNameScreen extends StatefulWidget {
  final String name;
  final String profileId;  // ← Nuevo
  const TraceNameScreen({
    Key? key,
    required this.name,
    required this.profileId,
  }) : super(key: key);

  @override
  _TraceNameScreenState createState() => _TraceNameScreenState();
}

class _TraceNameScreenState extends State<TraceNameScreen> {
  final List<Offset?> _points = [];
  final GlobalKey _strokeKey = GlobalKey();
  late final TextRecognizer _textRecognizer;
  bool _evaluating = false;
  bool _showTemplate = true;
  String? _result;

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer();
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  void _clear() {
    setState(() {
      _points.clear();
      _result = null;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = _strokeKey.currentContext!.findRenderObject() as RenderBox;
    final pt = box.globalToLocal(details.globalPosition);
    setState(() => _points.add(pt));
  }

  void _onPanEnd(DragEndDetails _) {
    _points.add(null);
  }

  Future<void> _evaluate() async {
    if (_points.isEmpty) return;
    setState(() {
      _showTemplate = false;
      _evaluating = true;
      _result = null;
    });
    await Future.delayed(const Duration(milliseconds: 50));

    // 1) Calcular longitud
    double total = 0;
    for (var i = 0; i < _points.length - 1; i++) {
      final p = _points[i], n = _points[i + 1];
      if (p != null && n != null) total += (n - p).distance;
    }
    const fontSize = 72.0;
    final threshold = widget.name.length * fontSize * 1.2;
    final lengthOk = total >= threshold;

    // 2) Capturar sólo la capa de trazos
    final boundary = _strokeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final img = await boundary.toImage(pixelRatio: 3.0);
    final bd  = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes = bd!.buffer.asUint8List();

    // 3) Guardar PNG en temp
    final dir  = await getTemporaryDirectory();
    final file = File('${dir.path}/trace_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);

    // 4) OCR
    final input = InputImage.fromFilePath(file.path);
    String ocrText = '';
    bool ocrOk = false;
    try {
      final rec = await _textRecognizer.processImage(input).timeout(const Duration(seconds: 5));
      ocrText = rec.text.trim();
      ocrOk = rec.text.toLowerCase().contains(widget.name.toLowerCase());
    } catch (_) {}

    // 5) Guardar resultado en Firestore
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('perfiles')
        .doc(widget.profileId)
        .collection('puntuaciones')
        .add({
      'tipo'     : 'trazar_nombre',
      'timestamp': FieldValue.serverTimestamp(),
      'longitud' : total,
      'umbral'   : threshold,
      'ocrText'  : ocrText,
      'passed'   : lengthOk && ocrOk,
    });

    // 6) Construir mensaje
    String msg;
    if (!lengthOk) {
      msg = 'Intenta de nuevo: ${total.toStringAsFixed(0)}px < umbral ${threshold.toStringAsFixed(0)}px';
    } else if (!ocrOk) {
      msg = 'Longitud OK, pero OCR detectó: "$ocrText"';
    } else {
      msg =
          '¡Bien hecho!\nLongitud ${total.toStringAsFixed(0)}px ≥ umbral ${threshold.toStringAsFixed(0)}px\nOCR: "$ocrText"';
    }

    setState(() {
      _showTemplate = true;
      _evaluating   = false;
      _result       = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traza tu nombre'),
        centerTitle: true,
        backgroundColor: colorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Traza tu nombre: "${widget.name}"',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            RepaintBoundary(
              key: _strokeKey,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    if (_showTemplate)
                      Center(
                        child: Text(
                          widget.name,
                          style: TextStyle(fontSize: 72, color: Colors.grey[300], fontWeight: FontWeight.bold),
                        ),
                      ),
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: _onPanUpdate,
                        onPanEnd: _onPanEnd,
                        child: CustomPaint(
                          painter: _DrawingPainter(points: _points),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.delete),
                  label: const Text('Borrar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: (_evaluating || _points.isEmpty) ? null : _evaluate,
                  icon: _evaluating
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: const Text('Evaluar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_result != null)
              Text(
                _result!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: _result!.startsWith('¡Bien') ? Colors.green : Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  const _DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent..strokeWidth = 6..strokeCap = StrokeCap.round;
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i], b = points[i + 1];
      if (a != null && b != null) {
        canvas.drawLine(a, b, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter old) => old.points != points;
}
