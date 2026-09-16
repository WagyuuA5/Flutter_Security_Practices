## 7. Input Validation & Sanitization

Mendemonstrasikan pencegahan injeksi dari sisi *client*.

**Fitur:**
- Menggunakan `RegExp` untuk memastikan nominal transfer hanya berisi angka positif bulat.
- Menolak karakter mencurigakan (`<`, `>`, kata `script`) pada field catatan transfer untuk mencegah XSS (Cross-Site Scripting).

### Threat -> Mitigasi -> Keterbatasan
- **Threat:** Penyerang mengirimkan *malicious payload* berupa script HTML/JS, query SQL, atau *overflow integer* (contoh: transfer nominal negatif untuk menambah saldo sendiri).
- **Mitigasi:** Memvalidasi tipe data, format, dan *range* menggunakan *Regex* sebelum *request* dikirim ke jaringan. Hal ini mencegah pengguna awam mengirim data sampah secara tidak sengaja dan meningkatkan UX.
- **Keterbatasan:** 
  - **SANGAT PENTING:** Validasi *client-side* (di dalam aplikasi Flutter) HANYA untuk User Experience. Ini sama sekali bukan tameng keamanan.
  - Peretas yang sebenarnya tidak akan menggunakan aplikasi Anda untuk mengirim payload. Mereka akan menggunakan *tools* seperti *Burp Suite*, *Postman*, atau skrip Python untuk mengirim *request HTTP* secara langsung ke Backend API Anda, sepenuhnya *bypass* aplikasi Flutter.
  - Oleh karena itu, logika yang sama (validasi dan sanitisasi) **WAJIB** diimplementasikan ulang secara ketat di sisi **Backend/Server**.
