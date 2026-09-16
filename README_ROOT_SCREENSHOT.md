## 6. Root/Jailbreak Detection & Screenshot Blocking

Mendemonstrasikan pencegahan kebocoran data di halaman sensitif ("Saldo Dummy") dari screenshot/screen recorder, serta mendeteksi kondisi perangkat.

**Fitur:**
- Menggunakan `flutter_windowmanager` untuk menambahkan `FLAG_SECURE` di Android pada halaman `BiometricLockScreen`.
- Menggunakan `safe_device` untuk mendeteksi status *rooted/jailbroken* dan menampilkan *warning banner* tanpa memblokir aplikasi secara total.

### Threat -> Mitigasi -> Keterbatasan
- **Threat (Root/Jailbreak):** Penyerang menggunakan *Frida* atau alat hooking lain pada perangkat yang sudah di-root untuk mengubah *state* memori aplikasi (misal mengubah nilai saldo di RAM) atau mencuri *key* yang sedang diproses.
- **Threat (Screenshot):** *Malware* perekam layar (Screenlogger) berjalan di *background* untuk menangkap informasi sensitif saat user membukanya, atau user sengaja/tidak sengaja melakukan screenshot informasi sensitif dan menyebarkannya.
- **Mitigasi:**
  - Mendeteksi root/jailbreak untuk memberikan peringatan dini atau membekukan fitur tertentu (membutuhkan keputusan produk). Di demo ini, kita tidak *force close* agar tidak menyulitkan *developer* (false positive) namun menampilkan *warning*.
  - Menggunakan `FLAG_SECURE` pada sistem operasi akan menyuruh OS merender tampilan menjadi hitam/kosong saat aplikasi direkam atau di-*screenshot*.
- **Keterbatasan:** 
  - Deteksi Root/Jailbreak adalah permainan "kucing-kucingan". Alat seperti *Magisk Hide*, *Shamiko*, atau fitur *root cloaking* lainnya dapat menyembunyikan status root dari *library* pendeteksi konvensional.
  - Fitur anti-screenshot/screen-recorder HANYA berjalan pada level OS (on-device). Penyerang masih bisa memotret layar menggunakan kamera HP lain (Optical/Physical Breach). Oleh karena itu, fitur ini lebih efektif untuk mencegah *malware screenlogger* ketimbang menghentikan niat fisik pengguna.
