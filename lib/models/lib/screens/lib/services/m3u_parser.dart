import 'package:iptv_player_mvp/models/channel.dart';

class M3UParser {
  /// Parseia um texto M3U (EXTINF + URL na linha seguinte) e devolve canais.
  static List<Channel> parse(String content) {
    final lines = content.split('\n');
    final channels = <Channel>[];

    String? name;
    String logo = '';
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      if (line.startsWith('#EXTINF')) {
        // Nome (depois da última vírgula)
        final nameMatch = RegExp(r',([^,]+)$').firstMatch(line);
        name = nameMatch?.group(1)?.trim();

        // Logo (tvg-logo="")
        final logoMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(line);
        logo = (logoMatch?.group(1) ?? '').trim();
      } else if (!line.startsWith('#')) {
        // URL do stream
        final url = line;
        if (name != null) {
          channels.add(Channel(name: name!, url: url, logo: logo));
        }
        name = null;
        logo = '';
      }
    }
    return channels;
  }
}
