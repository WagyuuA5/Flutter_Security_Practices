## 2. Biometric Lock

Mendemonstrasikan proteksi halaman sensitif menggunakan `local_auth`.

**Fitur:**
- Autentikasi biometrik (Fingerprint/FaceID) saat halaman dibuka.
- Fallback menggunakan PIN dari `flutter_secure_storage` apabila biometrik gagal atau tidak tersedia.
- Auto-lock (session timeout) jika tidak ada interaksi sentuhan (Listener) selama 15 detik.

### Threat -> Mitigasi -> Keterbatasan
- **Threat:** Seseorang meminjam HP user dalam keadaan tidak terkunci (unlocked) dan mencoba membuka aplikasi untuk melihat saldo atau melakukan transaksi.
- **Mitigasi:** Menerapkan `local_auth` memaksa verifikasi identitas (biometrik/PIN) setiap kali mengakses data sensitif, ditambah auto-lock agar sesi tidak dibiarkan terbuka terus menerus.
- **Keterbatasan:** 
  - Di Android, `local_auth` mengandalkan API biometrik sistem. Pada device yang di-root atau emulator, biometrik bisa di-bypass (misal via perintah `adb` atau modul Magisk) yang langsung mengembalikan nilai `true`. 
  - PIN fallback bergantung pada secure storage. Jika implementasi secure storage cacat, PIN dapat diekstrak.
  - Untuk aplikasi berisiko tinggi (fintech), jangan pernah percaya 100% pada hasil autentikasi lokal client. Transaksi tetap memerlukan verifikasi atau token kriptografi yang divalidasi oleh backend (misalnya menggunakan signature/keystore).
