import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nursecycle/core/colorconfig.dart'; // Pastikan primaryColor ada

class ReportDetailPage extends StatefulWidget {
  final Map<String, dynamic> identityData; // Data dari halaman list sebelumnya

  const ReportDetailPage({super.key, required this.identityData});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;

  // Data Holders
  Map<String, dynamic>? _antropometri;
  Map<String, dynamic>? _tanner;
  Map<String, dynamic>? _fisikPubertas;
  Map<String, dynamic>? _menstruasi; // Khusus Cewek
  Map<String, dynamic>? _psikososial; // Khusus Cowok (Cewek gabung di fisik)

  @override
  void initState() {
    super.initState();
    _fetchAllDetails();
  }

  Future<void> _fetchAllDetails() async {
    final userId = widget.identityData['user_id'];
    final gender = widget.identityData['gender']; // 'laki' atau 'perempuan'
    final createdAt = DateTime.parse(widget.identityData['created_at']);

    // Kita cari data dengan toleransi waktu +/- 5 detik dari data Identitas
    final timeStart =
        createdAt.subtract(const Duration(seconds: 5)).toIso8601String();
    final timeEnd = createdAt.add(const Duration(seconds: 5)).toIso8601String();

    try {
      // 1. Fetch Antropometri (Sama untuk Cowok/Cewek)
      final antroRes = await _supabase
          .from('screening_antropometri')
          .select()
          .eq('user_id', userId)
          .gte('created_at', timeStart)
          .lte('created_at', timeEnd)
          .limit(1)
          .maybeSingle();

      // 2. Fetch Data Pubertas (Sesuai Gender)
      Map<String, dynamic>? tannerRes;
      Map<String, dynamic>? fisikRes;
      Map<String, dynamic>? mensRes;
      Map<String, dynamic>? psikoRes;

      if (gender == 'laki') {
        // --- LAKI-LAKI ---
        final results = await Future.wait([
          _supabase
              .from('screening_puberty_male_tanner')
              .select()
              .eq('user_id', userId)
              .gte('created_at', timeStart)
              .lte('created_at', timeEnd)
              .limit(1)
              .maybeSingle(),
          _supabase
              .from('screening_puberty_male_fisik')
              .select()
              .eq('user_id', userId)
              .gte('created_at', timeStart)
              .lte('created_at', timeEnd)
              .limit(1)
              .maybeSingle(),
          _supabase
              .from('screening_puberty_male_psikososial')
              .select()
              .eq('user_id', userId)
              .gte('created_at', timeStart)
              .lte('created_at', timeEnd)
              .limit(1)
              .maybeSingle(),
        ]);
        tannerRes = results[0];
        fisikRes = results[1];
        psikoRes = results[2];
      } else {
        // --- PEREMPUAN ---
        final results = await Future.wait([
          _supabase
              .from('screening_puberty_female_tanner')
              .select()
              .eq('user_id', userId)
              .gte('created_at', timeStart)
              .lte('created_at', timeEnd)
              .limit(1)
              .maybeSingle(),
          _supabase
              .from('screening_puberty_female_fisik')
              .select()
              .eq('user_id', userId)
              .gte('created_at', timeStart)
              .lte('created_at', timeEnd)
              .limit(1)
              .maybeSingle(), // Fisik + Psikososial
          _supabase
              .from('screening_puberty_female_menstruasi')
              .select()
              .eq('user_id', userId)
              .gte('created_at', timeStart)
              .lte('created_at', timeEnd)
              .limit(1)
              .maybeSingle(),
        ]);
        tannerRes = results[0];
        fisikRes = results[1]; // Di tabel cewek, fisik & psikososial jadi satu
        mensRes = results[2];
      }

      if (mounted) {
        setState(() {
          _antropometri = antroRes;
          _tanner = tannerRes;
          _fisikPubertas = fisikRes;
          _menstruasi = mensRes;
          _psikososial = psikoRes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memuat detail: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMMM yyyy, HH:mm')
        .format(DateTime.parse(widget.identityData['created_at']));
    final isMale = widget.identityData['gender'] == 'laki';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Detail Laporan"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER SECTION ---
                  _buildHeaderCard(dateStr),
                  const SizedBox(height: 20),

                  // --- 1. ANTROPOMETRI ---
                  _buildSectionTitle("Antropometri"),
                  _buildAntropometriCard(),
                  const SizedBox(height: 20),

                  // --- 2. PUBERTAS (TANNER) ---
                  _buildSectionTitle("Tanda Seksual Sekunder"),
                  _buildTannerCard(isMale),
                  const SizedBox(height: 20),

                  // --- 3. KESEHATAN REPRODUKSI ---
                  _buildSectionTitle(
                      isMale ? "Fisik & Reproduksi" : "Menstruasi & Fisik"),
                  _buildReproCard(isMale),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  // === WIDGET BUILDERS ===

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  Widget _buildHeaderCard(String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nomor Skrining",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    widget.identityData['screening_number'] ?? '-',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                    widget.identityData['gender'].toString().toUpperCase(),
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              )
            ],
          ),
          const Divider(height: 24),
          _buildRowInfo("Nama", widget.identityData['full_name']),
          _buildRowInfo("Tanggal", date),
          _buildRowInfo("Sekolah", widget.identityData['school_class']),
        ],
      ),
    );
  }

  Widget _buildAntropometriCard() {
    final data = _antropometri;
    if (data == null) return const Text("- Data tidak ditemukan -");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildRowInfo("Tinggi Badan", "${data['height_cm']} cm"),
          _buildRowInfo("Berat Badan", "${data['weight_kg']} kg"),
          _buildRowInfo("IMT", "${data['imt']} (${data['status_gizi']})"),
          _buildRowInfo("Tekanan Darah", "${data['blood_pressure']}"),
          _buildRowInfo("Nadi", "${data['pulse_rate']} bpm"),
          if (data['chronic_disease'] != null && data['chronic_disease'] != '')
            _buildRowInfo("Riwayat", data['chronic_disease'], isLast: true),
        ],
      ),
    );
  }

  Widget _buildTannerCard(bool isMale) {
    final data = _tanner;
    if (data == null) return const Text("- Data tidak ditemukan -");

    if (isMale) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            _buildRowInfo("Ukuran Testis", data['tanner_testis']),
            _buildRowInfo("Rambut Kemaluan", data['tanner_pubic_hair']),
            _buildRowInfo(
                "Suara Pecah", data['voice_change'] == true ? "Ya" : "Tidak"),
            _buildRowInfo(
                "Kumis/Jenggot", data['beard_growth'] == true ? "Ya" : "Tidak",
                isLast: true),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            _buildRowInfo("Payudara", data['tanner_breasts']),
            _buildRowInfo("Rambut Kemaluan", data['tanner_pubic_hair']),
            _buildRowInfo(
                "Rambut Ketiak", data['axillary_hair'] == true ? "Ya" : "Tidak",
                isLast: true),
          ],
        ),
      );
    }
  }

  Widget _buildReproCard(bool isMale) {
    if (isMale) {
      final fisik = _fisikPubertas;
      final psiko = _psikososial;
      if (fisik == null) return const Text("- Data Fisik tidak ditemukan -");

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            _buildRowInfo("Jerawat", fisik['acne'] == true ? "Ya" : "Tidak"),
            _buildRowInfo(
                "Mimpi Basah", fisik['wet_dreams'] == true ? "Ya" : "Tidak"),
            _buildRowInfo("Emosi Labil",
                psiko?['emotion_uncontrolled'] == true ? "Ya" : "Tidak"),
            _buildRowInfo("Stress", psiko?['stress_history'] ?? "-",
                isLast: true),
          ],
        ),
      );
    } else {
      final fisik = _fisikPubertas;
      final mens = _menstruasi;
      if (fisik == null) return const Text("- Data tidak ditemukan -");

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            if (mens != null) ...[
              _buildRowInfo(
                  "Sudah Menarche", mens['menarche'] == true ? "Ya" : "Belum"),
              if (mens['menarche'] == true) ...[
                _buildRowInfo("Siklus", mens['cycle_regularity']),
                _buildRowInfo("Nyeri Haid", mens['pain_level']),
              ]
            ],
            const Divider(),
            _buildRowInfo("Jerawat", fisik['acne'] == true ? "Ya" : "Tidak"),
            _buildRowInfo("Stress", fisik['stress_history'] ?? "-",
                isLast: true),
          ],
        ),
      );
    }
  }

  Widget _buildRowInfo(String label, String? value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
