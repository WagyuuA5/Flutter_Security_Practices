import 'package:flutter/material.dart';

void main() {
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
              // TODO: Navigate to Secure Storage Demo
            },
          ),
          _buildMenuTile(
            context: context,
            title: '2. Biometric Lock',
            subtitle: 'Local auth with fallback PIN',
            onTap: () {
              // TODO: Navigate to Biometric Lock Demo
            },
          ),
          _buildMenuTile(
            context: context,
            title: '3. API Keys: .env vs --dart-define',
            subtitle: 'Secure configuration management',
            onTap: () {
              // TODO: Navigate to API Keys Demo
            },
          ),
          _buildMenuTile(
            context: context,
            title: '4. SSL Pinning',
            subtitle: 'Certificate and Public Key Pinning',
            onTap: () {
              // TODO: Navigate to SSL Pinning Demo
            },
          ),
          _buildMenuTile(
            context: context,
            title: '5. Obfuscation & Build Info',
            subtitle: 'App build properties',
            onTap: () {
              // TODO: Navigate to Obfuscation Demo
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
              // TODO: Navigate to Input Validation Demo
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
