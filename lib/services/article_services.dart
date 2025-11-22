import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/models/article.dart';

class ArticleService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get semua articles
  Future<List<Article>> getAllArticles() async {
    try {
      final response = await _supabase
          .from('articles')
          .select()
          .order('publish_date', ascending: false);

      return (response as List).map((json) => Article.fromJson(json)).toList();
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
          .order('publish_date', ascending: false);

      return (response as List).map((json) => Article.fromJson(json)).toList();
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
          .order('publish_date', ascending: false);

      return (response as List).map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil articles by category: $e');
    }
  }

  // Get single article by id
  Future<Article?> getArticleById(String id) async {
    try {
      final response =
          await _supabase.from('articles').select().eq('id', id).single();

      return Article.fromJson(response);
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
          .order('publish_date', ascending: false);

      return (response as List).map((json) => Article.fromJson(json)).toList();
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
          .order('publish_date', ascending: false)
          .range(from, to);

      return (response as List).map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil articles dengan pagination: $e');
    }
  }

  // Stream articles (realtime)
  Stream<List<Article>> streamArticles() {
    return _supabase
        .from('articles')
        .stream(primaryKey: ['id'])
        .order('publish_date', ascending: false)
        .map((data) => data.map((json) => Article.fromJson(json)).toList());
  }

  // Get distinct categories
  Future<List<String>> getCategories() async {
    try {
      final response =
          await _supabase.from('articles').select('category').order('category');

      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();

      return ['Semua', ...categories];
    } catch (e) {
      throw Exception('Gagal mengambil categories: $e');
    }
  }
}
