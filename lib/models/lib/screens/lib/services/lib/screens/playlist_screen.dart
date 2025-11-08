import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iptv_player_mvp/models/channel.dart';
import 'package:iptv_player_mvp/screens/player_screen.dart';
import 'package:iptv_player_mvp/services/m3u_parser.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Channel> channels = [];
  bool loading = false;
  String? error;

  Future<void> _loadFromUrl(String url) async {
    setState(() {
      loading = true;
      error = null;
      channels = [];
    });
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) throw HttpException('HTTP ${res.statusCode}');
      channels = M3UParser.parse(res.body);
    } catch (e) {
      error = 'Falha ao carregar playlist: $e';
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Playlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_link),
            tooltip: 'Carregar URL M3U',
            onPressed: () async {
              final url = await showDialog<String>(
                context: context,
                builder: (_) => const _UrlDialog(),
              );
              if (url != null && url.isNotEmpty) {
                _loadFromUrl(url.trim());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.paste),
            tooltip: 'Colar M3U (texto)',
            onPressed: () async {
              final text = await showDialog<String>(
                context: context,
                builder: (_) => const _PasteDialog(),
              );
              if (text != null && text.isNotEmpty) {
                setState(() {
                  channels = M3UParser.parse(text);
                });
              }
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : channels.isEmpty
                  ? const Center(
                      child: Text(
                        'Toque no ícone de link para carregar uma URL M3U\nou no ícone de colar para colar o conteúdo.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: channels.length,
                      itemBuilder: (_, i) {
                        final c = channels[i];
                        return ListTile(
                          leading: c.logo.isNotEmpty
                              ? Image.network(
                                  c.logo,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.live_tv),
                                )
                              : const Icon(Icons.live_tv),
                          title: Text(c.name),
                          subtitle: Text(c.url),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerScreen(channel: c),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}

class _UrlDialog extends StatefulWidget {
  const _UrlDialog();

  @override
  State<_UrlDialog> createState() => _UrlDialogState();
}

class _UrlDialogState extends State<_UrlDialog> {
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('URL da playlist M3U'),
      content: TextField(
        controller: ctrl,
        decoration:
            const InputDecoration(hintText: 'https://exemplo.com/minha.m3u'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, ctrl.text),
          child: const Text('Carregar'),
        ),
      ],
    );
  }
}

class _PasteDialog extends StatefulWidget {
  const _PasteDialog();

  @override
  State<_PasteDialog> createState() => _PasteDialogState();
}

class _PasteDialogState extends State<_PasteDialog> {
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Colar conteúdo M3U'),
      content: TextField(
        controller: ctrl,
        maxLines: 12,
        decoration: const InputDecoration(hintText: '#EXTM3U ...'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, ctrl.text),
          child: const Text('Usar'),
        ),
      ],
    );
  }
}
