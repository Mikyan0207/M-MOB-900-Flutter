class DroppedFile {

  const DroppedFile({
    required this.url,
    required this.name,
    required this.mime,
    required this.bytes,
  });
  final String url;
  final String name;
  final String mime;
  final int bytes;

  String get size {
    final double kb = bytes / 1024;
    final double mb = kb / 1024;

    return mb > 1.toDouble()
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
  }
}
