// 📄 lib/utils/exercise_generator.dart

import '../models/exercise.dart';
import '../models/user_profile.dart';

/// Genera dinámicamente una lista de ejercicios según el perfil
List<Exercise> generateExercises(UserProfile profile) {
  final list = <Exercise>[];

  // 1) Ejercicio de Colores (se manejará en 3 rondas en ExerciseScreen)
  list.add(const Exercise(
    title: 'Colores',
    question: '¿Cuál es el cuadrado?', // primera ronda
    assets: [
      'assets/images/triangle.png',
      'assets/images/circle.png',
      'assets/images/square.png',
    ],
    correctIndex: 2,
  ));

  // 2) Ejercicio de Contar (si es Verbal o conoce muchas palabras)
  if (profile.nivelHabla == 'Verbal' ||
      (profile.palabrasConocidas?.startsWith('+') ?? false)) {
    list.add(const Exercise(
      title: 'Contar',
      question: '¿Cuántos corazones hay?',
      assets: [
        'assets/images/heart.png',
        'assets/images/heart.png',
        'assets/images/heart.png',
      ],
      correctIndex: 3, // interpretamos “3 corazones”
    ));
  }

  // 3) Ejercicio Animales (siempre disponible)
  list.add(const Exercise(
    title: 'Animales',
    question: '¿Dónde está el gato?',
    assets: [
      'assets/images/cat.png',
      'assets/images/dog.png',
      'assets/images/bird.png',
    ],
    correctIndex: 0,
  ));

  // 4) Ejercicio de Ropa (siempre disponible)
  list.add(const Exercise(
    title: 'Ropa',
    question: '¿Cuál es la camisa?',
    assets: [
      'assets/images/shirt.png',
      'assets/images/pants.png',
      'assets/images/hat.png',
    ],
    correctIndex: 0,
  ));

  // 5) Ejercicio “Tu nombre” (solo si puede decir su nombre)
  if (profile.puedeDecirNombre == true) {
    list.add(const Exercise(
      title: 'Tu nombre',
      question: '¿Cómo te llamas?',
      assets: [], // activa la entrada de texto
      correctIndex: 0,
    ));
  }

  return list;
}
