import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/models/article.dart';

class ArticleService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get semua articles
  Future<List<Article>> getAllArticles() async {
    try {
      final response = await _supabase.from('articles').select().order(
          'created_at',
          ascending: false); // Gunakan created_at sesuai DB

      // Ubah dari .fromJson ke .fromMap
      return (response as List<dynamic>)
          .map((data) => Article.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data articles: $e');
    }
  }

  // Get featured articles
  Future<List<Article>> getFeaturedArticles() async {
    try {
      final response = await _supabase
          .from('articles')
          .select()
          .eq('is_featured', true)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((data) => Article.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil featured articles: $e');
    }
  }

  // Get articles by category
  Future<List<Article>> getArticlesByCategory(String category) async {
    try {
      final response = await _supabase
          .from('articles')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((data) => Article.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil articles by category: $e');
    }
  }

  // Get single article by id
  Future<Article?> getArticleById(String id) async {
    try {
      final response =
          await _supabase.from('articles').select().eq('id', id).single();

      // Single response langsung berupa Map
      return Article.fromMap(response);
    } catch (e) {
      throw Exception('Gagal mengambil article: $e');
    }
  }

  // Search articles
  Future<List<Article>> searchArticles(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllArticles();
      }

      final response = await _supabase
          .from('articles')
          .select()
          .or('title.ilike.%$query%,excerpt.ilike.%$query%,author.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((data) => Article.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari articles: $e');
    }
  }

  // Get articles with pagination
  Future<List<Article>> getArticlesPaginated({
    required int page,
    required int pageSize,
  }) async {
    try {
      final from = page * pageSize;
      final to = from + pageSize - 1;

      final response = await _supabase
          .from('articles')
          .select()
          .order('created_at', ascending: false)
          .range(from, to);

      return (response as List<dynamic>)
          .map((data) => Article.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil articles dengan pagination: $e');
    }
  }

  // Stream articles (realtime)
  Stream<List<Article>> streamArticles() {
    return _supabase
        .from('articles')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => Article.fromMap(item)).toList());
  }

  // Get distinct categories
  Future<List<String>> getCategories() async {
    try {
      final response =
          await _supabase.from('articles').select('category').order('category');

      final categories = (response as List<dynamic>)
          .map((item) => item['category'] as String)
          .toSet() // Hapus duplikat
          .toList();

      // Tambahkan opsi 'Semua' di awal
      return ['Semua', ...categories];
    } catch (e) {
      throw Exception('Gagal mengambil categories: $e');
    }
  }
}
