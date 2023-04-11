class Viewer {
  final bool muted;
  Viewer({
    required this.muted,
  });

  Map<String, dynamic> toMap() {
    return {
      'muted': muted,
    };
  }
}
