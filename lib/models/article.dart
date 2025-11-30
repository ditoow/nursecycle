class Article {
  final String id;
  final String title;
  final String excerpt;
  final String? content; // Isi lengkap
  final String category;
  final String author;
  final String readTime;
  final String imageUrl;
  final double rating;
  final String publishDate;
  final bool isFeatured;

  Article({
    required this.id,
    required this.title,
    required this.excerpt,
    this.content,
    required this.category,
    required this.author,
    required this.readTime,
    required this.imageUrl,
    required this.rating,
    required this.publishDate,
    this.isFeatured = false,
  });

  // Parsing dari Supabase (DB -> App)
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      excerpt: map['excerpt'] ?? '',
      content: map['content'], // ✅ Pastikan ini diambil
      category: map['category'] ?? 'Umum',
      author: map['author'] ?? 'Admin',
      readTime: map['read_time'] ?? '3 menit', // snake_case dari DB
      imageUrl: map['image_url'] ?? '', // snake_case dari DB
      rating: (map['rating'] ?? 0.0).toDouble(),
      publishDate: map['created_at'] ?? DateTime.now().toIso8601String(),
      isFeatured: map['is_featured'] ?? false, // snake_case dari DB
    );
  }

  // Konversi ke Supabase (App -> DB)
  // Kita buat bersih tanpa ID dan Date (biar DB yang generate)
  Map<String, dynamic> toMapForDB() {
    return {
      // 'id': id, // Jangan kirim ID jika Create (Insert)
      'title': title,
      'excerpt': excerpt,
      'content': content, // ✅ Wajib dikirim
      'category': category,
      'author': author,
      'read_time': readTime, // Pastikan key ini sama dengan nama kolom DB
      'image_url': imageUrl, // Pastikan key ini sama dengan nama kolom DB
      'rating': rating,
      'is_featured': isFeatured,
      // 'created_at': ... // Jangan kirim, biarkan auto-generate
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) => Article.fromMap(json);

  // ✅ TAMBAHAN: toJson (Untuk kebutuhan encode jika ada)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'category': category,
      'author': author,
      'read_time': readTime,
      'image_url': imageUrl,
      'rating': rating,
      'is_featured': isFeatured,
    };
  }
}
