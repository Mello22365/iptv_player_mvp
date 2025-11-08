class Channel {
  final String name;
  final String url;
  final String logo;

  Channel({
    required this.name,
    required this.url,
    required this.logo,
  });

  factory Channel.fromM3U(String line) {
    final nameRegex = RegExp(r'tvg-name="([^"]+)"');
    final logoRegex = RegExp(r'tvg-logo="([^"]+)"');

    final nameMatch = nameRegex.firstMatch(line);
    final logoMatch = logoRegex.firstMatch(line);

    final name = nameMatch != null ? nameMatch.group(1)! : 'Sem nome';
    final logo = logoMatch != null ? logoMatch.group(1)! : '';
    final url = line.split('\n').last.trim();

    return Channel(name: name, url: url, logo: logo);
  }
}
