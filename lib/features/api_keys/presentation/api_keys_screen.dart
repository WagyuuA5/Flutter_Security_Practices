import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeysScreen extends StatelessWidget {
  const ApiKeysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Read from .env
    final envApiKey = dotenv.env['API_KEY'] ?? 'Not found in .env';
    
    // Read from --dart-define
    const dartDefineApiKey = String.fromEnvironment('API_KEY', defaultValue: 'Not found in dart-define');

    return Scaffold(
      appBar: AppBar(title: const Text('3. API Keys')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Perbandingan cara menyimpan konfigurasi/API Key.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildKeyCard(
              title: 'Dari .env (flutter_dotenv)',
              value: envApiKey,
              color: Colors.orange.shade100,
              description: 'Nilai dibaca dari file .env yang di-bundle sebagai asset.',
            ),
            const SizedBox(height: 16),
            _buildKeyCard(
              title: 'Dari --dart-define',
              value: dartDefineApiKey,
              color: Colors.green.shade100,
              description: 'Nilai disuntikkan saat kompilasi:\nflutter run --dart-define=API_KEY=xxx',
            ),
            const SizedBox(height: 32),
            const Text(
              '⚠️ PENTING:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kedua cara di atas BUKAN untuk menyimpan rahasia produksi (production secret). '
              'File .env dapat diekstrak karena ikut di-bundle dalam APK/IPA. '
              'Sedangkan --dart-define tertanam dalam native binary yang juga bisa di-reverse engineering.\n\n'
              'Satu-satunya tempat aman untuk secret sungguhan adalah Backend Server (proxy).',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyCard({
    required String title,
    required String value,
    required Color color,
    required String description,
  }) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
