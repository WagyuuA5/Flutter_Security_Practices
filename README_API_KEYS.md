## 3. Menyembunyikan API Keys: `.env` vs `--dart-define`

Mendemonstrasikan dua cara umum mengelola konfigurasi aplikasi (seperti URL backend, API key).

**Fitur:**
- Menggunakan `flutter_dotenv` untuk membaca konfigurasi dari file `.env`.
- Menggunakan `String.fromEnvironment` untuk membaca konfigurasi dari build arguments (`--dart-define`).

### Threat -> Mitigasi -> Keterbatasan
- **Threat:** Seseorang mendekompilasi APK/IPA (menggunakan apktool, dll) dan mengekstrak API key yang di-*hardcode* di dalam kode. Penyerang menggunakan API key tersebut untuk menghabiskan kuota layanan berbayar (misalnya Google Maps API, Firebase, Midtrans, dll) atau membobol sistem.
- **Mitigasi:** Menggunakan `.env` mencegah key masuk ke *version control* (GitHub), sehingga repository publik/private tetap bersih dari secret. Menggunakan `--dart-define` menyematkan key langsung pada saat kompilasi CI/CD, yang sedikit lebih tersamar dibanding `.env` yang berupa plain-text asset.
- **Keterbatasan:** 
  - **Kedua cara tersebut TIDAK AMAN untuk menyimpan *production secret*.** File `.env` disertakan sebagai aset (biasanya di `assets/.env`) di dalam APK dan sangat mudah diekstrak. `--dart-define` memang dikompilasi ke dalam native library (misal `libapp.so`), namun nilainya tetap dapat ditemukan dengan perintah dasar seperti `strings libapp.so`.
  - **Satu-satunya mitigasi sejati:** Jangan pernah menyimpan kredensial berharga tinggi di aplikasi *client*. Pindahkan logika pemanggilan API ke *Backend proxy* milik Anda sendiri. Aplikasi hanya berkomunikasi ke *Backend* Anda, lalu *Backend* yang menyuntikkan API key asli dan meneruskannya ke layanan pihak ketiga.
