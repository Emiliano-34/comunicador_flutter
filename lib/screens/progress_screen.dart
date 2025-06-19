import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressScreen extends StatelessWidget {
  final String profileId;
  const ProgressScreen({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final scoresRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('perfiles')
        .doc(profileId)
        .collection('puntuaciones')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Progreso del perfil')),
      body: StreamBuilder<QuerySnapshot>(
        stream: scoresRef.snapshots(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No hay registros aún'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (c, i) {
              final d = docs[i].data()! as Map<String, dynamic>;
              final tipo   = d['tipo']   as String? ?? '';
              final passed = d['passed']  as bool?   ?? false;
              final len    = d['longitud'] as num?;
              final thr    = d['umbral']   as num?;
              final ocr    = d['ocrText']  as String? ?? '';
              final ts     = (d['timestamp'] as Timestamp?)?.toDate();
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(
                    passed ? Icons.check_circle : Icons.error,
                    color: passed ? Colors.green : Colors.red,
                  ),
                  title: Text(tipo),
                  subtitle: Text(
                    '${len   != null ? 'Longitud: ${len.toStringAsFixed(0)}px\n' : ''}'
                    '${thr   != null ? 'Umbral:   ${thr.toStringAsFixed(0)}px\n' : ''}'
                    '${ocr.isNotEmpty          ? 'OCR:      "$ocr"\n'           : ''}'
                    'Fecha: ${ts  != null ? ts.toLocal().toString().split('.').first : '—'}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
