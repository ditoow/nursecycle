import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:nursecycle/screens/kalender/kalenderpage.dart'; // Opsional: Jika ingin navigasi saat diklik

class KalenderHaid extends StatefulWidget {
  const KalenderHaid({super.key});

  @override
  State<KalenderHaid> createState() => _KalenderHaidState();
}

class _KalenderHaidState extends State<KalenderHaid> {
  bool _isLoading = true;
  Map<String, dynamic>? _lastCycle;

  // Variabel Tampilan
  String _lastPeriodDate = "-";
  String _nextPeriodDate = "-";
  String _daysUntilNext = "-";
  bool _isOverdue = false;

  @override
  void initState() {
    super.initState();
    _fetchLastCycle();
  }

  Future<void> _fetchLastCycle() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      // Ambil 1 siklus terakhir
      final response = await Supabase.instance.client
          .from('menstrual_cycles')
          .select()
          .eq('user_id', user.id)
          .order('start_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _lastCycle = response;
          _calculateDates();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _calculateDates() {
    if (_lastCycle == null) return;

    final startDateStr = _lastCycle!['start_date'] as String;
    final startDate = DateTime.parse(startDateStr);

    // Format Tanggal Terakhir
    _lastPeriodDate = DateFormat('d MMM yyyy').format(startDate);

    // Hitung Prediksi (Asumsi siklus 28 hari)
    final nextDate = startDate.add(const Duration(days: 28));
    _nextPeriodDate = DateFormat('d MMM yyyy').format(nextDate);

    // Hitung Selisih Hari
    final today = DateTime.now();
    // Reset jam/menit agar akurat hitung hari
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final nextMidnight = DateTime(nextDate.year, nextDate.month, nextDate.day);

    final difference = nextMidnight.difference(todayMidnight).inDays;

    if (difference < 0) {
      _isOverdue = true;
      _daysUntilNext = "Terlambat ${difference.abs()} hari";
    } else if (difference == 0) {
      _daysUntilNext = "Haid diprediksi hari ini";
    } else {
      _daysUntilNext = "$difference hari lagi";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
          height: 100, child: Center(child: CircularProgressIndicator()));
    }

    // Jika belum ada data, tampilkan card ajakan
    if (_lastCycle == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.pink.shade100),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.pink[300], size: 30),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Belum ada data haid.\nCatat siklus pertamamu sekarang!",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigasi ke Kalender Page Lengkap (Tab 2)
            // (context.findAncestorStateOfType<State<StatefulWidget>>() as dynamic)._onItemTapped(1);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B9D).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFFF6B9D),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Kalender Haid',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.grey[400], size: 16),
                  ],
                ),
                const SizedBox(height: 16),

                // Periode terakhir
                Row(
                  children: [
                    Icon(Icons.event, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Periode Terakhir: ',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Text(
                      _lastPeriodDate,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Perkiraan berikutnya
                Row(
                  children: [
                    Icon(Icons.event_note, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Perkiraan Berikutnya: ',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Text(
                      _nextPeriodDate,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Badge waktu (Dinamis Warna)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _isOverdue ? Colors.red[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isOverdue
                          ? Colors.red.shade200
                          : Colors.orange.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color:
                            _isOverdue ? Colors.red[700] : Colors.orange[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _daysUntilNext,
                        style: TextStyle(
                          color:
                              _isOverdue ? Colors.red[700] : Colors.orange[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
