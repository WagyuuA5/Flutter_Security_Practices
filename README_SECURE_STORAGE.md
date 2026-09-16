## 1. Secure Storage

Aplikasi ini mendemonstrasikan penggunaan lutter_secure_storage untuk menyimpan data sensitif seperti token atau PIN pengguna.

**Mekanisme Penyimpanan:**
- **iOS:** Menggunakan Keychain Services. Data dienkripsi secara native oleh sistem operasi dan terkait erat dengan aplikasi.
- **Android:** Menggunakan EncryptedSharedPreferences. Kunci enkripsi disimpan di Android Keystore sehingga lebih aman dari ekstraksi statis.

**Kapan data ini hilang?**
- Jika user melakukan uninstall aplikasi, data di EncryptedSharedPreferences (Android) biasanya ikut terhapus (kecuali Auto Backup Android 6+ menyimpannya, meski secara default secure preferences di-exclude jika disetting benar). Pada iOS, data Keychain *bisa saja* bertahan setelah uninstall (tergantung versi iOS/setting), dan baru hilang total jika direset/dihapus eksplisit atau factory reset.
- Level keamanan ini lebih baik dibanding penyimpanan biasa seperti shared_preferences biasa, namun tetap memiliki keterbatasan.

### Threat -> Mitigasi -> Keterbatasan
- **Threat:** Penyerang yang mendapat akses fisik ke device atau membaca file system aplikasi (malware) mencoba mencuri token sesi atau PIN pengguna.
- **Mitigasi:** Menyimpan data menggunakan lutter_secure_storage memastikan data dienkripsi (EncryptedSharedPreferences/Keychain) bukan sekadar plaintext di XML/JSON.
- **Keterbatasan:** Jika device di-root/jailbreak, penyerang dengan akses root *bisa saja* melakukan hook pada proses aplikasi saat runtime atau mengekstrak kunci dari Keystore/Keychain. Secure storage hanya melindungi data saat *at rest*, bukan saat proses memori berjalan.
