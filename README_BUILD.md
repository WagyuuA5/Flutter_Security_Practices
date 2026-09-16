## 5. Obfuscation & Build Info

Aplikasi Dart dikompilasi ke bentuk native (AOT) di mode *release*. Namun, simbol-simbol (nama kelas, fungsi, variabel) masih bisa dibaca dengan alat reverse engineering. Obfuscation bertujuan mengubah nama-nama tersebut menjadi karakter tak bermakna (seperti `a`, `b`, `c`), sehingga memperlambat peretas dalam memahami logika aplikasi.

### Cara Membangun Aplikasi Obfuscated

Sebuah script sederhana tersedia di `scripts/build_secure_release.sh`:

```bash
flutter build apk --release --obfuscate --split-debug-info=build/symbols
```
*(Catatan: ganti `apk` dengan `ipa` atau `appbundle` sesuai target platform)*

### Cara De-Obfuscate Stack Trace (Saat Terjadi Crash)
Anda WAJIB menyimpan folder `build/symbols` setiap kali melakukan rilis ke PlayStore/AppStore. Jika terjadi error di production, stack trace-nya tidak akan bisa dibaca kecuali Anda men-deobfuscate menggunakan file symbol yang cocok:

```bash
flutter symbolize -i <obfuscated_stack_trace_file> -d build/symbols/app.android-arm64.symbols
```

### Threat -> Mitigasi -> Keterbatasan
- **Threat:** Peretas mendekompilasi / reverse-engineering aplikasi (misalnya APK) untuk mencari celah keamanan, logika bisnis rahasia, algoritma eksklusif, atau letak URL dan kunci kriptografi yang disembunyikan dalam source code.
- **Mitigasi:** Obfuscation (penyamaran kode). Membaca dan menganalisis kode yang diobfuscate membutuhkan usaha, waktu, dan keahlian yang jauh lebih besar, sehingga mematahkan niat peretas pemula atau *script kiddies*.
- **Keterbatasan:** 
  - Obfuscation **BUKAN** pencegahan total. Peretas yang persisten dan mahir tetap bisa menganalisis jalannya program melalui *dynamic analysis* (menggunakan debugger, Frida) tanpa perlu membaca nama fungsi yang sebenarnya.
  - Obfuscation bukan pengganti validasi di sisi server.
