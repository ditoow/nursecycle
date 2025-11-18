# nursecycle

Aplikasi Flutter untuk manajemen siklus kesehatan remaja.

## Struktur Folder

```
lib/
│
├── main.dart
│
├── core/
│   ├── colorconfig.dart
│   ├── inputformat.dart
│   └── theme.dart
│
├── models/
│   ├── article.dart
│   └── chatmessage.dart
│
├── screens/
│   ├── mainpage.dart
│   ├── article/
│   │   ├── articlepage.dart
│   │   ├── detailarticle.dart
│   │   └── ...
│   ├── auth/
│   │   ├── loginpage.dart
│   │   ├── registerpage.dart
│   │   └── widgets/
│   │       └── _textfields.dart
│   ├── chat/
│   │   ├── chatpage.dart
│   │   └── widgets/
│   │       ├── attachment.dart
│   │       └── chatbubble.dart
│   ├── home/
│   │   ├── homepage.dart
│   │   └── widgets/
│   │       └── kalenderhaid.dart
│   ├── kalender/
│   │   └── kalenderpage.dart
│   └── screening/
│       ├── antropometri.dart
│       ├── identitasremaja.dart
│       ├── pubertaslaki/
│       │   ├── pemeriksaanfisikreproduksi.dart
│       │   ├── perubahanfisiologis.dart
│       │   ├── psikologissosiallaki.dart
│       │   ├── pubertaslaki.dart
│       │   └── seksualsekunderlaki.dart
│       ├── pubertasperempuan/
│       │   ├── kebersihanreproduksi.dart
│       │   ├── menarche_fields.dart
│       │   ├── menstruasi.dart
│       │   ├── pemeriksaanfisik.dart
│       │   ├── psikologsocial.dart
│       │   ├── pubertasperempuan.dart
│       │   └── seksualsekunder.dart
│       └── widgets/
│           └── formscreening.dart
```

## Penjelasan Garis Besar Folder

- **lib/main.dart**
  Entry point aplikasi.

- **core/**
  Konfigurasi warna, input, dan tema aplikasi.

- **models/**
  Model data seperti artikel dan pesan chat.

- **screens/**
  Halaman-halaman utama aplikasi, terbagi menjadi beberapa subfolder:
  - **mainpage.dart**: Halaman utama.
  - **article/**: Halaman daftar dan detail artikel.
  - **auth/**: Halaman login, register, dan widget input.
  - **chat/**: Halaman chat dan widget pendukung.
  - **home/**: Halaman home dan widget kalender haid.
  - **kalender/**: Halaman kalender siklus.
  - **screening/**: Halaman dan widget untuk screening kesehatan, terbagi untuk pubertas laki-laki dan perempuan.

---
