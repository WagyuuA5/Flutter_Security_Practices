import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuildInfoScreen extends StatelessWidget {
  const BuildInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5. Obfuscation & Build Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Halaman ini menampilkan informasi mode build aplikasi saat ini.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 24),
            const Text(
              'Catatan Penting Obfuscation:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Obfuscation hanya bekerja pada saat aplikasi di-build dalam Release Mode.\n'
              '2. Gunakan perintah berikut untuk build obfuscated:\n'
              '   flutter build apk --obfuscate --split-debug-info=build/symbols\n'
              '3. Folder build/symbols HARUS disimpan dengan aman. Tanpa file tersebut, Anda tidak akan bisa membaca stack trace jika terjadi crash di production.\n'
              '4. Untuk membaca stack trace yang obfuscated, gunakan perintah:\n'
              '   flutter symbolize -i <obfuscated_stack_trace_file> -d out/android/app.android-arm64.symbols',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: kReleaseMode ? Colors.green.shade100 : Colors.orange.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              kReleaseMode ? Icons.verified_user : Icons.warning_amber_rounded,
              size: 48,
              color: kReleaseMode ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              kReleaseMode ? 'RELEASE MODE' : 'DEBUG / PROFILE MODE',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              kReleaseMode 
                  ? 'Aplikasi sedang berjalan di Release Mode. Jika Anda mem-build dengan flag --obfuscate, kode Dart Anda saat ini tersamar.' 
                  : 'Aplikasi TIDAK berjalan di Release Mode. Obfuscation tidak aktif di mode ini.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
