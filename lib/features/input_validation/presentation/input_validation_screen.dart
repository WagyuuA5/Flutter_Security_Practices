import 'package:flutter/material.dart';

class InputValidationScreen extends StatefulWidget {
  const InputValidationScreen({super.key});

  @override
  State<InputValidationScreen> createState() => _InputValidationScreenState();
}

class _InputValidationScreenState extends State<InputValidationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _result = '';

  // Validasi: Hanya boleh angka positif
  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nominal tidak boleh kosong';
    }
    final regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(value)) {
      return 'Nominal hanya boleh berisi angka (tanpa titik/koma/minus)';
    }
    final amount = int.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Nominal harus lebih dari 0';
    }
    return null; // Valid
  }

  // Validasi/Sanitasi: Mencegah injeksi tag script dasar
  String? _validateNote(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opsional
    }
    // Mencegah tanda kurung sudut (angle brackets) yang sering dipakai XSS
    final xssRegex = RegExp(r'[<>]');
    if (xssRegex.hasMatch(value)) {
      return 'Catatan mengandung karakter yang dilarang (< atau >)';
    }
    // Mencegah kata 'script'
    if (value.toLowerCase().contains('script')) {
      return 'Catatan terdeteksi mengandung script';
    }
    return null; // Valid
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _result = 'Transfer Rp ${_amountController.text} berhasil diproses.\nCatatan: ${_noteController.text}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validasi Client-Side Lulus!')),
      );
    } else {
      setState(() {
        _result = '';
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7. Input Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Demo validasi form client-side. Coba masukkan angka minus, koma, atau tag HTML <script> di catatan.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Nominal Transfer (Rp)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateAmount,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Transfer',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLength: 50,
                  validator: _validateNote,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Kirim Transfer'),
                ),
                const SizedBox(height: 32),
                if (_result.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade50,
                    child: Text(
                      _result,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(height: 32),
                const Text(
                  '⚠️ KETERBATASAN CLIENT-SIDE:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Validasi di aplikasi Flutter (seperti di atas) HANYA berguna untuk UX (User Experience) agar user tidak salah input.\n\n'
                  'Peretas dapat dengan mudah membypass aplikasi dan menembak API backend secara langsung menggunakan Postman/cURL.\n\n'
                  'Validasi & sanitisasi sesungguhnya WAJIB dilakukan kembali di Backend.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
