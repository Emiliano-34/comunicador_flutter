import '../models/exercise.dart';
import '../models/user_profile.dart';

List<Exercise> generateExercises(UserProfile profile) {
  // ─── Ejercicio: Colores
  const colores = ['azul', 'amarillo', 'verde'];
  const assetColores = [
    'assets/images/square.png',
    'assets/images/triangle.png',
    'assets/images/circle.png',
  ];
  final roundsColores = List<Round>.generate(
    colores.length,
    (i) => Round(
      question: '¿Qué figura es de color ${colores[i]}?',
      assets: assetColores,
      options: ['Cuadrado', 'Triángulo', 'Círculo'],
      correctIndex: i,
    ),
  );

  // ─── Ejercicio: Animales
  const animales = ['gato', 'perro', 'pájaro'];
  const assetAnimales = [
    'assets/images/cat.png',
    'assets/images/dog.png',
    'assets/images/bird.png',
  ];
  final roundsAnimales = List<Round>.generate(
    animales.length,
    (i) => Round(
      question: '¿Dónde está el ${animales[i]}?',
      assets: assetAnimales,
      options: ['Gato', 'Perro', 'Pájaro'],
      correctIndex: i,
    ),
  );

  // ─── Ejercicio: Ropa
  const prendas = ['camisa', 'pantalones', 'sombrero'];
  const assetRopa = [
    'assets/images/shirt.png',
    'assets/images/pants.png',
    'assets/images/hat.png',
  ];
  final roundsRopa = List<Round>.generate(
    prendas.length,
    (i) => Round(
      question: '¿Cuál es la ${prendas[i]}?',
      assets: assetRopa,
      options: ['Camisa', 'Pantalones', 'Sombrero'],
      correctIndex: i,
    ),
  );

  // ─── Ejercicio: Planas de tu nombre (ejemplo: "Lucas")
  const nombre = 'Lucas';
  final roundsPlana = List<Round>.generate(
    5,
    (i) => Round(
      question: 'Escribe tu nombre: intento ${i + 1}',
      expectedAnswer: nombre,
    ),
  );

  return [
    Exercise(title: 'Colores', rounds: roundsColores),
    Exercise(title: 'Animales', rounds: roundsAnimales),
    Exercise(title: 'Ropa', rounds: roundsRopa),
    Exercise(title: 'Planas de tu nombre', rounds: roundsPlana),
  ];
}
