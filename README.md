# nursecycle

nursecycle adalah aplikasi Flutter untuk manajemen siklus kesehatan remaja, membantu pengguna memantau siklus, edukasi kesehatan, dan konsultasi dengan tenaga kesehatan.

## Fitur Utama

- **Manajemen Siklus**: Kalender haid dan pubertas.
- **Artikel Edukasi**: Daftar dan detail artikel kesehatan remaja.
- **Chat**: Konsultasi dengan tenaga kesehatan melalui chat.
- **Screening Kesehatan**: Formulir screening untuk remaja laki-laki dan perempuan.
- **Autentikasi**: Login dan registrasi pengguna.

## Struktur Folder Utama

```
lib/
  main.dart                # Entry point aplikasi
  core/                    # Konfigurasi warna, input, tema
  models/                  # Model data (artikel, chat, dsb)
  screens/                 # Halaman utama & subfolder fitur
	 article/               # Halaman artikel
	 auth/                  # Login, register, widget input
	 chat/                  # Chat & widget pendukung
	 home/                  # Home & kalender haid
	 kalender/              # Kalender siklus
	 screening/             # Screening kesehatan remaja
assets/
  fonts/                   # Font custom
  images/                  # Gambar & logo
```

## Dependensi Utama

- [Flutter](https://flutter.dev/)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [supabase_flutter](https://pub.dev/packages/supabase_flutter)
- [intl](https://pub.dev/packages/intl)
- [table_calendar](https://pub.dev/packages/table_calendar)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)

## Cara Build & Menjalankan

1. **Clone repo & install dependencies**
   ```bash
   git clone <repo-url>
   cd nursecycle
   flutter pub get
   ```
2. **Atur file .env**
   - Buat file `.env` di root, isi dengan `SUPABASE_URL` dan `SUPABASE_ANON_KEY` dari dashboard Supabase.
3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## Kontribusi

Pull request dan issue sangat terbuka untuk pengembangan lebih lanjut.

---

_Aplikasi ini dikembangkan menggunakan Flutter, dengan backend Supabase, dan mengutamakan edukasi serta kesehatan remaja._
