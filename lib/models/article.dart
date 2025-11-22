class Article {
  final String id;
  final String title;
  final String excerpt;
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
    required this.category,
    required this.author,
    required this.readTime,
    required this.imageUrl,
    required this.rating,
    required this.publishDate,
    this.isFeatured = false,
  });

  // Factory constructor untuk parsing dari JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? '',
      readTime: json['read_time'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      publishDate: json['publish_date'] as String? ?? '',
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'category': category,
      'author': author,
      'read_time': readTime,
      'image_url': imageUrl,
      'rating': rating,
      'publish_date': publishDate,
      'is_featured': isFeatured,
    };
  }
}
