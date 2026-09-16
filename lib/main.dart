import 'package:flutter_security_practices/features/input_validation/presentation/input_validation_screen.dart';
import 'package:flutter_security_practices/features/build_info/presentation/build_info_screen.dart';
import 'package:flutter_security_practices/features/ssl_pinning/presentation/ssl_pinning_screen.dart';
import 'package:flutter_security_practices/features/api_keys/presentation/api_keys_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_security_practices/features/biometric/presentation/biometric_lock_screen.dart';
import 'package:flutter_security_practices/features/secure_storage/presentation/secure_storage_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const SecurityPracticesApp());
}

class SecurityPracticesApp extends StatelessWidget {
  const SecurityPracticesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Security Practices',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Practices Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          _buildMenuTile(
            context: context,
            title: '1. Secure Storage',
            subtitle: 'Store tokens & PINs securely',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecureStorageScreen()));
            },
          ),
          _buildMenuTile(
            context: context,
            title: '2. Biometric Lock',
            subtitle: 'Local auth with fallback PIN',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BiometricLockScreen()));
            },
          ),
          _buildMenuTile(
            context: context,
            title: '3. API Keys: .env vs --dart-define',
            subtitle: 'Secure configuration management',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ApiKeysScreen()));
            },
          ),
          _buildMenuTile(
            context: context,
            title: '4. SSL Pinning',
            subtitle: 'Certificate and Public Key Pinning',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SslPinningScreen()));
            },
          ),
          _buildMenuTile(
            context: context,
            title: '5. Obfuscation & Build Info',
            subtitle: 'App build properties',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BuildInfoScreen()));
            },
          ),
          _buildMenuTile(
            context: context,
            title: '6. Root/Jailbreak & Screenshot Block',
            subtitle: 'Environment checks',
            onTap: () {
              // TODO: Navigate to Root Check Demo
            },
          ),
          _buildMenuTile(
            context: context,
            title: '7. Input Validation & Sanitization',
            subtitle: 'Defense in depth at client side',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const InputValidationScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}







