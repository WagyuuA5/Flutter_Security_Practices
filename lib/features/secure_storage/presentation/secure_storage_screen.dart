import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageScreen extends StatefulWidget {
  const SecureStorageScreen({super.key});

  @override
  State<SecureStorageScreen> createState() => _SecureStorageScreenState();
}

class _SecureStorageScreenState extends State<SecureStorageScreen> {
  final _storage = const FlutterSecureStorage();
  final _tokenController = TextEditingController();
  final _pinController = TextEditingController();
  
  String? _savedToken;
  String? _savedPin;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await _storage.read(key: 'dummy_token');
    final pin = await _storage.read(key: 'dummy_pin');
    setState(() {
      _savedToken = token;
      _savedPin = pin;
    });
  }

  Future<void> _saveData() async {
    await _storage.write(key: 'dummy_token', value: _tokenController.text);
    await _storage.write(key: 'dummy_pin', value: _pinController.text);
    _tokenController.clear();
    _pinController.clear();
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data securely saved!')),
      );
    }
  }

  Future<void> _deleteData() async {
    await _storage.delete(key: 'dummy_token');
    await _storage.delete(key: 'dummy_pin');
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data securely deleted!')),
      );
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1. Secure Storage')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter dummy data to store securely. This data uses Keychain on iOS and EncryptedSharedPreferences on Android.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Dummy Token',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'Dummy PIN',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Save Data'),
            ),
            const Divider(height: 32),
            const Text('Stored Data:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Token: ${_savedToken ?? 'Not set'}'),
            Text('PIN: ${_savedPin ?? 'Not set'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _deleteData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
              child: const Text('Delete Data', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
