# Flutter Security Practices

This repository serves as an interactive demonstration of various security techniques in Flutter applications. It covers essential security implementations ranging from secure data storage, biometric authentication, API key management, SSL Pinning, screenshot prevention, root/jailbreak detection, to code obfuscation and input validation.

---

## 🔒 OWASP MASVS (Mobile Application Security Verification Standard) - Basic Checklist

This basic security checklist is adapted from OWASP best practices for mobile applications.

- [x] **V1: Architecture, Design and Threat Modeling**
  - All secrets (API Keys) are assumed to be extractable from the client side. Real secrets must reside on the backend.
- [x] **V2: Data Storage and Privacy**
  - [x] No passwords or sensitive data are stored in plain `SharedPreferences`. Everything utilizes iOS Keychain and Android Keystore (via `flutter_secure_storage`).
  - [x] Implements `FLAG_SECURE` to prevent sensitive data from being captured by screenshots or screen recorders.
- [x] **V3: Cryptography**
  - Relies on the platform's built-in cryptographic implementations (Android Keystore / iOS Keychain) rather than custom encryption algorithms.
- [x] **V4: Authentication and Session Management**
  - [x] Local authentication (Biometric/PIN) is required to access sensitive pages.
  - [x] Auto-lock (Client-side session timeout) activates after a brief period of inactivity.
- [x] **V5: Network Communication**
  - [x] All traffic enforces TLS/HTTPS.
  - [x] Implements SSL Pinning (`badCertificateCallback`) to prevent Man-in-the-Middle (MitM) attacks via rogue CA certificates.
- [x] **V6: Platform Interaction**
  - [x] User inputs are validated and sanitized using Regex on the client side before processing/sending (Note: Backend validation is still mandatory).
- [x] **V7: Code Quality and Build Setting**
  - [x] Utilizes code obfuscation to hinder reverse engineering attempts.
  - [x] Displays warnings when the device is detected as Rooted, Jailbroken, or running on an Emulator.
  - [x] Includes a CI pipeline (GitHub Actions) to validate linting and unit testing.

---

## 📚 Features & Implementation Details

### 1. Secure Storage

Demonstrates the use of `flutter_secure_storage` to securely store sensitive data such as user tokens or PINs.

**Storage Mechanism:**
- **iOS:** Uses Keychain Services. Data is natively encrypted by the operating system.
- **Android:** Uses EncryptedSharedPreferences. The encryption key is stored in the Android Keystore, making static extraction significantly harder.

**Threat Model & Mitigation:**
- **Threat:** An attacker gaining physical access or file system access (via malware) attempts to steal session tokens.
- **Mitigation:** Storing data using `flutter_secure_storage` ensures encryption at rest.
- **Limitation:** On rooted/jailbroken devices, attackers can still hook into the application memory or extract keys. Secure storage only protects data *at rest*.

**lib/features/secure_storage/data/secure_storage_service.dart**
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  SecureStorageService(this._storage);

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'dummy_token', value: token);
  }
}
```

### 2. Biometric Authentication & Session Timeout

Demonstrates how to lock sensitive screens using `local_auth` and automatically lock the screen after 15 seconds of inactivity using `Listener`.

**Threat Model & Mitigation:**
- **Threat:** An unauthorized person takes over the device while the app is left open by the legitimate user.
- **Mitigation:** Sensitive pages require Biometric/PIN authentication and automatically lock after an idle timeout.
- **Limitation:** Fallback PINs rely on Secure Storage. If the Secure Storage is compromised (e.g., via root access), the fallback PIN can be bypassed.

### 3. API Key Management (`.env` vs `--dart-define`)

Demonstrates the differences and limitations of storing API keys in client-side applications.

**Threat Model & Mitigation:**
- **Threat:** Attackers extract API keys from the application binary or asset files.
- **Mitigation:** Using `.env` prevents keys from being committed to version control. Using `--dart-define` embeds the key during compilation, making it slightly harder to extract than plain-text assets.
- **Limitation:** **Neither method is secure for production secrets.** `.env` files can be easily extracted from the APK. `--dart-define` strings can still be found using simple reverse engineering tools like `strings`.
- **True Mitigation:** Never store high-value secrets on the client app. Use a backend proxy server to inject keys and communicate with third-party services.

### 4. SSL Pinning

Validates server certificates manually using `dio` and `badCertificateCallback`.

**Threat Model & Mitigation:**
- **Threat:** Man-in-the-Middle (MitM) attacks where an attacker intercepts HTTPS traffic using a rogue CA certificate.
- **Mitigation:** SSL/Certificate Pinning verifies the server's certificate fingerprint against a hardcoded fingerprint in the app. If they don't match, the connection is dropped.
- **Limitation:** Makes certificate rotation difficult (requires app updates). Can be bypassed on rooted devices using tools like Frida or Xposed.

**scripts/get_fingerprint.sh**
```bash
# Retrieve SHA-1 fingerprint for pinning
echo | openssl s_client -connect jsonplaceholder.typicode.com:443 2>/dev/null | openssl x509 -noout -fingerprint -sha1
```

### 5. Build Obfuscation & Security Info

Obfuscates the compiled binary to make reverse engineering difficult.

**Threat Model & Mitigation:**
- **Threat:** Attackers decompile the application to reverse engineer business logic, proprietary algorithms, or find hidden endpoints.
- **Mitigation:** Obfuscation (name mangling) significantly increases the time and expertise required to understand the decompiled code.
- **Limitation:** Obfuscation is not absolute prevention. Persistent attackers can still use dynamic analysis (debuggers) to understand the program flow without knowing the original function names.

**scripts/build_secure_release.sh**
```bash
# Build APK with obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### 6. Root/Jailbreak Detection & Screenshot Blocking

Prevents data leaks on sensitive pages by blocking screenshots and detects if the device is rooted/jailbroken.

**Threat Model & Mitigation:**
- **Threat:** Screenlogger malware running in the background captures sensitive information, or attackers use hooking tools (Frida) on rooted devices to alter memory states.
- **Mitigation:** `FLAG_SECURE` instructs the OS to render the screen black during screen recording or screenshots. `safe_device` detects root access to provide early warnings.
- **Limitation:** Root detection is a cat-and-mouse game; tools like Magisk Hide can bypass it. Screenshot blocking only works on-device and cannot prevent physical cameras from taking photos of the screen.

### 7. Input Validation & Sanitization

Demonstrates client-side injection prevention.

**Threat Model & Mitigation:**
- **Threat:** Attackers send malicious payloads (HTML/JS scripts, SQL queries, or integer overflows).
- **Mitigation:** Validating data types, formats, and ranges using Regex before sending requests improves UX and prevents accidental invalid inputs.
- **Limitation:** **CRITICAL:** Client-side validation is strictly for User Experience. Attackers can bypass the app entirely and send malicious HTTP requests directly to the backend API. **Backend validation is absolutely mandatory.**

