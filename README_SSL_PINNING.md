## 4. SSL Pinning

Demo memvalidasi sertifikat server secara manual menggunakan dio dan `badCertificateCallback`.
Untuk mendapatkan fingerprint dari suatu domain, kita bisa menggunakan OpenSSL (script tersedia di `scripts/get_fingerprint.sh`):

```bash
# SHA-256
echo | openssl s_client -connect jsonplaceholder.typicode.com:443 2>/dev/null | openssl x509 -noout -fingerprint -sha256

# SHA-1
echo | openssl s_client -connect jsonplaceholder.typicode.com:443 2>/dev/null | openssl x509 -noout -fingerprint -sha1
```

### Threat -> Mitigasi -> Keterbatasan
- **Threat:** Serangan Man-in-the-Middle (MitM) di mana penyerang berada dalam satu jaringan (misalnya public WiFi) atau menanamkan CA certificate palsu ke device korban untuk menyadap lalu lintas HTTPS (contoh: Charles Proxy, Burp Suite).
- **Mitigasi:** Menggunakan SSL/Certificate Pinning. Aplikasi tidak hanya mengecek apakah sertifikat tersebut valid menurut sistem operasi, tetapi mengecek apakah *fingerprint* sertifikat atau *public key*-nya sama persis dengan yang kita simpan di dalam kode aplikasi. Jika berbeda, aplikasi langsung memutus koneksi.
- **Keterbatasan:** 
  - Menyulitkan rotasi sertifikat. Jika sertifikat server kedaluwarsa atau dirotasi lebih cepat dan aplikasi belum diupdate di PlayStore/AppStore, koneksi akan gagal dan aplikasi tidak bisa dipakai (brick). Perlu strategi seperti mem-pin beberapa sertifikat sekaligus (termasuk sertifikat backup/intermediate).
  - Di *rooted/jailbroken* device, pinning sangat mudah di-bypass menggunakan alat seperti *Frida*, *Objection*, atau *Xposed modules* (misalnya JustTrustMe). SSL Pinning menaikkan tingkat kesulitan, tetapi tidak mustahil ditembus oleh penyerang dengan akses penuh ke perangkat.
