class M3UParser {
  List<String> parse(String content) {
    final lines = content.split('\n');
    final urls = <String>[];

    for (var line in lines) {
      if (line.startsWith('http')) {
        urls.add(line.trim());
      }
    }

    return urls;
  }
}
