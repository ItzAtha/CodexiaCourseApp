class TypeWritingEffect {
  final String text;
  final Duration duration;

  TypeWritingEffect({required this.text, this.duration = const Duration(milliseconds: 50)});

  Stream<String> animate() async* {
    for (int i = 0; i < text.length; i++) {
      yield text.substring(0, i + 1);
      await Future.delayed(duration);
    }
  }
}
