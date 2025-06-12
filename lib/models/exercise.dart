class Round {
  final List<String> assets;     // rutas de imagen (opcional)
  final List<String> options;    // etiquetas (opcional)
  final String question;         // texto de la pregunta
  final int? correctIndex;       // índice de la opción correcta (solo para selección)
  final String? expectedAnswer;  // respuesta esperada (solo para escritura)

  Round({
    required this.question,
    this.assets = const [],
    this.options = const [],
    this.correctIndex,
    this.expectedAnswer,
  });
}

class Exercise {
  final String title;           // p.ej. "Colores"
  final List<Round> rounds;

  Exercise({
    required this.title,
    required this.rounds,
  });
}
