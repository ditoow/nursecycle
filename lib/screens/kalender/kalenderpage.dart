import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nursecycle/core/colorconfig.dart'; // Pastikan primaryColor ada

class Kalenderpage extends StatefulWidget {
  const Kalenderpage({super.key});

  @override
  State<Kalenderpage> createState() => _KalenderpageState();
}

class _KalenderpageState extends State<Kalenderpage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Data Siklus dari Database
  List<Map<String, dynamic>> _cycles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCycles();
  }

  // --- 1. FETCH DATA DARI SUPABASE ---
  Future<void> _fetchCycles() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('menstrual_cycles')
          .select()
          .eq('user_id', user.id)
          .order('start_date', ascending: false);

      setState(() {
        _cycles = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  // --- 2. SIMPAN DATA BARU ---
  Future<void> _addCycle(DateTime start, DateTime end) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      await Supabase.instance.client.from('menstrual_cycles').insert({
        'user_id': user.id,
        'start_date': DateFormat('yyyy-MM-dd').format(start),
        'end_date': DateFormat('yyyy-MM-dd').format(end),
        'notes': 'Dicatat dari aplikasi',
      });

      await _fetchCycles(); // Refresh data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Siklus haid berhasil dicatat!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    }
  }

  // --- LOGIKA WARNA KALENDER (Haid vs Prediksi) ---
  bool _isMenstruating(DateTime day) {
    for (var cycle in _cycles) {
      final start = DateTime.parse(cycle['start_date']);
      final end = cycle['end_date'] != null
          ? DateTime.parse(cycle['end_date'])
          : start.add(const Duration(days: 5)); // Default 5 hari jika end null

      // Cek apakah hari ini ada di dalam range start-end (normalisasi jam ke 00:00)
      if (isSameDay(day, start) ||
          isSameDay(day, end) ||
          (day.isAfter(start) && day.isBefore(end))) {
        return true;
      }
    }
    return false;
  }

  bool _isPrediction(DateTime day) {
    if (_cycles.isEmpty) return false;
    // Ambil siklus terakhir
    final lastCycle = _cycles.first;
    final lastStart = DateTime.parse(lastCycle['start_date']);

    // Prediksi sederhana: +28 hari dari start terakhir
    final nextStart = lastStart.add(const Duration(days: 28));
    final nextEnd = nextStart.add(const Duration(days: 5));

    if (isSameDay(day, nextStart) ||
        isSameDay(day, nextEnd) ||
        (day.isAfter(nextStart) && day.isBefore(nextEnd))) {
      return true;
    }
    return false;
  }

  // --- DIALOG INPUT TANGGAL ---
  void _showAddDialog() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 5)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      _addCycle(pickedRange.start, pickedRange.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false, // Tidak perlu lagi jika pakai ScrollView
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Hilangkan back button default (karena ini tab utama)
        backgroundColor: primaryColor, // Gunakan warna pink/utama
        elevation: 0,
        centerTitle: false, // Rata kiri seperti ArticlePage
        title: const Text(
          'Kalender Siklus Haid',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20, // Sesuaikan ukuran font agar proporsional
          ),
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Pastikan ikon (jika ada) berwarna putih
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              // ✅ Ganti Column dengan CustomScrollView
              slivers: [
                // 1. BAGIAN ATAS (Kalender & Legenda) - Dibuat Scrollable
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            if (_isMenstruating(day)) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  day.day.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            } else if (_isPrediction(day)) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  day.day.toString(),
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Legenda
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem(primaryColor, "Haid"),
                            _buildLegendItem(Colors.orange, "Prediksi"),
                          ],
                        ),
                      ),
                      const Divider(height: 30),
                    ],
                  ),
                ),

                // 2. BAGIAN BAWAH (List Riwayat) - Menggunakan SliverList
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: _cycles.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Center(
                            child: Text("Belum ada data siklus.",
                                style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final cycle = _cycles[index];
                              final start = DateTime.parse(cycle['start_date']);
                              final end = cycle['end_date'] != null
                                  ? DateTime.parse(cycle['end_date'])
                                  : null;
                              final duration = end != null
                                  ? end.difference(start).inDays + 1
                                  : '?';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        primaryColor.withValues(alpha: 0.1),
                                    child: Icon(Icons.water_drop,
                                        color: primaryColor),
                                  ),
                                  title: Text(
                                    DateFormat('d MMMM yyyy').format(start),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    end != null
                                        ? 'Sampai ${DateFormat('d MMMM').format(end)} ($duration hari)'
                                        : 'Sedang berlangsung',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.grey),
                                    onPressed: () async {
                                      await Supabase.instance.client
                                          .from('menstrual_cycles')
                                          .delete()
                                          .eq('id', cycle['id']);
                                      _fetchCycles();
                                    },
                                  ),
                                ),
                              );
                            },
                            childCount: _cycles.length,
                          ),
                        ),
                ),

                // Spacer bawah agar list tidak tertutup FAB
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Catat Haid", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
