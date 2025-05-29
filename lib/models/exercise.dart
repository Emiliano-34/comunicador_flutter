// 📄 lib/models/exercise.dart
class Exercise {
  final String title;
  final String question;
  final List<String> assets;
  final int correctIndex;

  const Exercise({
    required this.title,
    required this.question,
    required this.assets,
    required this.correctIndex,
  });
}
