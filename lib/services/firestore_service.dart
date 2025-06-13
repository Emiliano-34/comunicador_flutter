import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Guarda un nuevo perfil con sus respuestas en Firestore
  Future<void> saveProfileWithAnswers({
    required String profileName,
    required int age,
    required String nivel,
    required Map<String, dynamic> answers,
  }) async {
    final uid = _auth.currentUser!.uid;

    // 1) Crea el perfil y obtén su ID
    final perfilRef = await _db
      .collection('usuarios')
      .doc(uid)
      .collection('perfiles')
      .add({
        'nombre': profileName,
        'edad': age,
        'nivel': nivel,
        'fechaCreacion': FieldValue.serverTimestamp(),
      });

    // 2) Guarda cada respuesta en subcolección "respuestas"
    final batch = _db.batch();
    answers.forEach((questionKey, response) {
      final respRef = perfilRef.collection('respuestas').doc();
      batch.set(respRef, {
        'preguntaKey': questionKey,
        'respuesta': response,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
    return batch.commit();
  }
}