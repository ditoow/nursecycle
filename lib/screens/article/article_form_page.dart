import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:nursecycle/models/article.dart';

class ArticleFormPage extends StatefulWidget {
  final Article? article; // Jika null = Tambah Baru, Jika ada = Edit

  const ArticleFormPage({super.key, this.article});

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _excerptController;
  late TextEditingController _contentController; // Isi artikel lengkap
  late TextEditingController _imageUrlController;
  late TextEditingController _readTimeController;

  String _selectedCategory = 'Pubertas';
  bool _isFeatured = false;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Pubertas',
    'Nutrisi',
    'Olahraga',
    'Mental',
    'Kebersihan',
    'Seksualitas',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill jika mode edit
    final a = widget.article;
    _titleController = TextEditingController(text: a?.title ?? '');
    _excerptController = TextEditingController(text: a?.excerpt ?? '');
    _contentController = TextEditingController(text: a?.content ?? '');
    _imageUrlController = TextEditingController(text: a?.imageUrl ?? '');
    _readTimeController = TextEditingController(text: a?.readTime ?? '5 menit');
    if (a != null) {
      _selectedCategory =
          _categories.contains(a.category) ? a.category : _categories[0];
      _isFeatured = a.isFeatured;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _readTimeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final user = Supabase.instance.client.auth.currentUser;

    final data = {
      'title': _titleController.text.trim(),
      'excerpt': _excerptController.text.trim(),
      'content': _contentController.text.trim(),
      'category': _selectedCategory,
      'image_url': _imageUrlController.text.trim(),
      'read_time': _readTimeController.text.trim(),
      'is_featured': _isFeatured,
      'author': user?.email?.split('@')[0] ?? 'Admin',
      'rating': widget.article?.rating ?? 0.0,
      'publish_date':
          widget.article?.publishDate ?? DateTime.now().toIso8601String(),
    };

    try {
      if (widget.article == null) {
        // CREATE
        await Supabase.instance.client.from('articles').insert(data);
      } else {
        // UPDATE
        await Supabase.instance.client
            .from('articles')
            .update(data)
            .eq('id', widget.article!.id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.article == null
                  ? 'Artikel berhasil ditambahkan!'
                  : 'Artikel diperbarui!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article == null ? "Tambah Artikel" : "Edit Artikel"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: 'Judul Artikel', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // KATEGORI DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                    labelText: 'Kategori', border: OutlineInputBorder()),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),

              // RINGKASAN (EXCERPT)
              TextFormField(
                controller: _excerptController,
                decoration: const InputDecoration(
                    labelText: 'Ringkasan Singkat',
                    border: OutlineInputBorder()),
                maxLines: 2,
                validator: (v) => v!.isEmpty ? 'Ringkasan wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // ISI KONTEN (CONTENT)
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi Lengkap Artikel',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 10, // Area teks besar
                validator: (v) => v!.isEmpty ? 'Konten wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // URL GAMBAR
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                    labelText: 'URL Gambar (Link)',
                    border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'URL Gambar wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // WAKTU BACA
              TextFormField(
                controller: _readTimeController,
                decoration: const InputDecoration(
                    labelText: 'Estimasi Waktu Baca',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // FEATURED SWITCH
              SwitchListTile(
                title: const Text("Jadikan Artikel Pilihan?"),
                value: _isFeatured,
                activeThumbColor: primaryColor,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              const SizedBox(height: 24),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3, // Biar tidak terlalu tipis
                          ),
                        )
                      : const Text("Simpan Artikel",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
