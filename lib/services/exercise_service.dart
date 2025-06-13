// lib/services/exercise_service.dart

import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../utils/exercise_generator.dart';

/// Servicio para obtener listas de ejercicios basadas en el perfil del usuario.
class ExerciseService {
  /// Devuelve todos los ejercicios generados para este perfil.
  static List<Exercise> getExercises(UserProfile profile) {
    return generateExercises(profile);
  }

  /// Si quieres ejercicios por título, por ejemplo “Planas de tu nombre”:
  static List<Exercise> getPlanasExercises(UserProfile profile) {
    return generateExercises(profile)
        .where((e) => e.title == 'Planas de tu nombre')
        .toList();
  }

  /// Ejercicios de selección de imágenes (colores, animales, ropa…)
  static List<Exercise> getSelectionExercises(UserProfile profile) {
    return generateExercises(profile)
        .where((e) => e.title != 'Planas de tu nombre')
        .toList();
  }
}