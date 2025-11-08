import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// servidor que você rodou no Termux
const String kAuthBase = 'http://127.0.0.1:3000';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final macCtrl = TextEditingController();
  final keyCtrl = TextEditingController();
  bool loading = false;

  Future<void> _doLogin() async {
    final mac = macCtrl.text.trim();
    final deviceKey = keyCtrl.text.trim();
    if (mac.isEmpty || deviceKey.isEmpty) {
      _toast('Preencha MAC e Device Key');
      return;
    }

    setState(() => loading = true);
    try {
      final res = await http.post(
        Uri.parse('$kAuthBase/auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mac': mac, 'deviceKey': deviceKey}),
      );

      if (res.statusCode == 200 && res.body.contains('"ok":true')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('mac', mac);
        await prefs.setString('device_key', deviceKey);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/playlist');
      } else {
        _toast('MAC/Key inválidos');
      }
    } catch (e) {
      _toast('Erro de rede: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login IPTV')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: macCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'MAC (ex: FD:9D:32:DF:83:3C)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keyCtrl,
              decoration: const InputDecoration(labelText: 'Device Key'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _doLogin,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
