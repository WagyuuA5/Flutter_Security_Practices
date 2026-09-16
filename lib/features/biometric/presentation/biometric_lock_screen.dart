import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:safe_device/safe_device.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool _isAuthenticated = false;
  String _pinFallback = '';
  final TextEditingController _pinController = TextEditingController();
  
  Timer? _idleTimer;
  static const int _idleTimeoutSeconds = 15;

  bool _isJailBroken = false;
  bool _isRealDevice = true;

  @override
  void initState() {
    super.initState();
    _secureScreen();
    _checkDeviceStatus();
    _checkBiometric();
  }

  Future<void> _secureScreen() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  Future<void> _checkDeviceStatus() async {
    bool isJailBroken = false;
    bool isRealDevice = true;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      isRealDevice = await SafeDevice.isRealDevice;
    } catch (e) {
      debugPrint(e.toString());
    }
    if (mounted) {
      setState(() {
        _isJailBroken = isJailBroken;
        _isRealDevice = isRealDevice;
      });
    }
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    if (_isAuthenticated) {
      _idleTimer = Timer(const Duration(seconds: _idleTimeoutSeconds), () {
        setState(() {
          _isAuthenticated = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired due to inactivity.')),
        );
      });
    }
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    if (canCheckBiometrics) {
      bool didAuthenticate = false;
      try {
        didAuthenticate = await _auth.authenticate(
          localizedReason: 'Please authenticate to view sensitive data',
          biometricOnly: true,
        );
      } on PlatformException catch (e) {
        debugPrint(e.toString());
      }
      
      // Fallback untuk backward compatibility/perbaikan plugin sebelumnya
      if (!didAuthenticate && !mounted) return;
      if (didAuthenticate) {
        setState(() {
          _isAuthenticated = true;
        });
        _resetIdleTimer();
        return;
      }
    }
    
    // Fallback to PIN
    final savedPin = await _storage.read(key: 'dummy_pin');
    setState(() {
      _pinFallback = savedPin ?? '';
    });
  }

  void _verifyPin() {
    if (_pinController.text == _pinFallback && _pinFallback.isNotEmpty) {
      setState(() {
        _isAuthenticated = true;
      });
      _resetIdleTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid PIN. Please try again.')),
      );
    }
    _pinController.clear();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _pinController.dispose();
    if (Platform.isAndroid) {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetIdleTimer(),
      child: Scaffold(
        appBar: AppBar(title: const Text('2. Biometric & Secure View')),
        body: Column(
          children: [
            if (_isJailBroken)
              Container(
                width: double.infinity,
                color: Colors.red,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'WARNING: Root/Jailbreak Detected!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            if (!_isRealDevice)
              Container(
                width: double.infinity,
                color: Colors.orange,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'WARNING: Emulator/Simulator Detected!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: _isAuthenticated ? _buildSensitiveContent() : _buildFallbackLogin(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensitiveContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_open, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'Saldo Dummy',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rp 1.000.000.000',
            style: TextStyle(fontSize: 32, color: Colors.green),
          ),
          const SizedBox(height: 32),
          Text(
            'Halaman ini akan terkunci otomatis\ndalam $_idleTimeoutSeconds detik jika tidak ada aktivitas.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Text(
            'Halaman ini DIPROTEKSI oleh FLAG_SECURE (Android).\nCoba screenshot atau screen record!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackLogin() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Biometric authentication failed or not available.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (_pinFallback.isNotEmpty) ...[
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'Enter PIN from Secure Storage',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyPin,
              child: const Text('Verify PIN'),
            ),
          ] else ...[
            const Text(
              'No PIN found. Please set a dummy PIN in the Secure Storage demo first.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ]
        ],
      ),
    );
  }
}
