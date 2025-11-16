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
}
