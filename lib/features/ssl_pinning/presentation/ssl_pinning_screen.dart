import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class SslPinningScreen extends StatefulWidget {
  const SslPinningScreen({super.key});

  @override
  State<SslPinningScreen> createState() => _SslPinningScreenState();
}

class _SslPinningScreenState extends State<SslPinningScreen> {
  String _status = 'Idle';
  String _response = '';

  // Untuk demo, kita gunakan SHA-1 karena tersedia langsung di X509Certificate (dart:io).
  // Di production, disarankan menggunakan SHA-256 (bisa di-hash dari cert.der menggunakan package crypto).
  final String _expectedSha1 = '88 F4 0C 04 94 1C 2E A2 D5 7F FF C4 55 ED 17 E3 E6 92 BE B5';
  
  final String _wrongSha1 = '00 11 22 33 44 55 66 77 88 99 AA BB CC DD EE FF 00 11 22 33';

  Future<void> _fetchData({required bool useCorrectFingerprint}) async {
    setState(() {
      _status = 'Fetching...';
      _response = '';
    });

    final dio = Dio();
    final fingerprintToMatch = useCorrectFingerprint ? _expectedSha1 : _wrongSha1;

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        // Menggunakan badCertificateCallback untuk validasi fingerprint secara manual
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          final certFingerprint = cert.sha1
              .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
              .join(' ');
          
          if (certFingerprint == fingerprintToMatch) {
            return true; // Valid, lanjutkan
          }
          return false; // Invalid, tolak koneksi
        };
        return client;
      },
    );

    try {
      final res = await dio.get('https://jsonplaceholder.typicode.com/posts/1');
      setState(() {
        _status = 'Success (Pinning OK)';
        _response = res.data.toString();
      });
    } on DioException catch (e) {
      setState(() {
        _status = 'Failed (Pinning Rejected)';
        _response = e.message ?? e.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error';
        _response = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4. SSL Pinning')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Demo SSL Pinning menggunakan Dio dan badCertificateCallback. Membandingkan SHA-1 fingerprint dari server dengan yang sudah kita pin di dalam aplikasi.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _fetchData(useCorrectFingerprint: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
              child: const Text('Test with CORRECT Fingerprint', style: TextStyle(color: Colors.green)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchData(useCorrectFingerprint: false),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
              child: const Text('Test with WRONG Fingerprint', style: TextStyle(color: Colors.red)),
            ),
            const Divider(height: 32),
            Text('Status: $_status', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _response,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
