// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:nursecycle/core/inputformat.dart';
import 'package:nursecycle/screens/screening/antropometri.dart';
import 'package:nursecycle/screens/screening/widgets/formscreening.dart';
import 'package:nursecycle/models/screening_data.dart';

final TextEditingController namalengkapcontroller = TextEditingController();
final TextEditingController tanggallahircontroller = TextEditingController();
final TextEditingController usiacontroller = TextEditingController();
final TextEditingController sekolahkelascontroller = TextEditingController();
final TextEditingController alamatcontroller = TextEditingController();
final TextEditingController ortuwalicontroller = TextEditingController();
final TextEditingController kontakcontroller = TextEditingController();

class Identitasremaja extends StatefulWidget {
  const Identitasremaja({super.key});

  @override
  State<Identitasremaja> createState() => _IdentitasremajaState();
}

class _IdentitasremajaState extends State<Identitasremaja> {
  late final TextEditingController namalengkapcontroller;
  late final TextEditingController tanggallahircontroller;
  late final TextEditingController usiacontroller;
  late final TextEditingController sekolahkelascontroller;
  late final TextEditingController alamatcontroller;
  late final TextEditingController ortuwalicontroller;
  late final TextEditingController kontakcontroller;

  // final bool _isDataLoading = true;
  String selectedGender = 'laki';
  bool isLoading = false; // ✅ State untuk loading data lama
  DateTime? selectedDate;

  void _preFill(TextEditingController controller, dynamic value) {
    if (value != null) {
      controller.text = value.toString();
    }
  }

  Future<void> _loadExistingData() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (mounted) setState(() => isLoading = true);

    if (user == null) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      return;
    }

    try {
      // 1. MULAI LOADING DATA LAMA DARI SEMUA TABEL SECARA BERSAMAAN
      // Kita ambil record terbaru dari setiap tabel menggunakan Future.wait
      final results = await Future.wait([
        // 0: Identity
        Supabase.instance.client
            .from('screening_identity')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
        // 1: Antropometri
        Supabase.instance.client
            .from('screening_antropometri')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
        // 2: Pubertas Male - Tanner
        Supabase.instance.client
            .from('screening_puberty_male_tanner')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
        // 3: Pubertas Male - Fisik
        Supabase.instance.client
            .from('screening_puberty_male_fisik')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
        // 4: Pubertas Male - Psikososial
        Supabase.instance.client
            .from('screening_puberty_male_psikososial')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
        // 5: Pubertas Female - Tanner
        Supabase.instance.client
            .from('screening_puberty_female_tanner')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
        // 6: Pubertas Female - Fisik
        Supabase.instance.client
            .from('screening_puberty_female_fisik')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
        // 7: Pubertas Female - Psikososial
        Supabase.instance.client
            .from('screening_puberty_female_menstruasi')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(),
      ]);

      // Kita asumsikan response[0] adalah data Identitas terbaru.
      final identityData = results[0];
      final antropometriData = results[1];

      // 2. PRE-FILL CONTROLLERS (Data Identitas)
      if (identityData != null) {
        _preFill(namalengkapcontroller, identityData['full_name']);
        // ... (lanjutkan pre-fill untuk semua controller Identitas)
        // ...
      }

      // 3. UPDATE MODEL DENGAN SEMUA DATA DARI DB
      _updateModelFromDb(identityData, antropometriData, results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat data lama: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Tambahkan method ini untuk menghindari error
  void _updateModelFromDb(
      dynamic identityData, dynamic antropometriData, List<dynamic> results) {
    // Implementasi sederhana: pre-fill controller jika data ada
    if (identityData != null) {
      _preFill(namalengkapcontroller, identityData['full_name']);
      _preFill(sekolahkelascontroller, identityData['school_class']);
      _preFill(alamatcontroller, identityData['address']);
      _preFill(ortuwalicontroller, identityData['parent_name']);
      _preFill(kontakcontroller, identityData['contact_number']);
      if (identityData['gender'] != null) {
        setState(() {
          selectedGender = identityData['gender'];
        });
      }
      if (identityData['birth_date'] != null) {
        try {
          final birthDate = DateTime.parse(identityData['birth_date']);
          selectedDate = birthDate;
          tanggallahircontroller.text =
              DateFormat('d MMMM yyyy').format(birthDate);
          final now = DateTime.now();
          int age = now.year - birthDate.year;
          if (now.month < birthDate.month ||
              (now.month == birthDate.month && now.day < birthDate.day)) {
            age--;
          }
          usiacontroller.text = '$age Tahun';
        } catch (_) {}
      }
    }
    // Anda bisa menambahkan pre-fill untuk antropometriData dan tabel lain jika diperlukan
  }

  @override
  void initState() {
    // --- INIT CONTROLLER ---
    namalengkapcontroller = TextEditingController();
    tanggallahircontroller = TextEditingController();
    usiacontroller = TextEditingController();
    sekolahkelascontroller = TextEditingController();
    alamatcontroller = TextEditingController();
    ortuwalicontroller = TextEditingController();
    kontakcontroller = TextEditingController();
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    namalengkapcontroller.dispose();
    tanggallahircontroller.dispose();
    usiacontroller.dispose();
    sekolahkelascontroller.dispose();
    alamatcontroller.dispose();
    ortuwalicontroller.dispose();
    kontakcontroller.dispose();
    super.dispose();
  }

  Future<void> _collectAndContinue() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Anda harus login untuk menyimpan data.')),
        );
      }
      return;
    }

    if (namalengkapcontroller.text.isEmpty || selectedDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nama Lengkap dan Tanggal Lahir wajib diisi.')),
        );
      }
      return;
    }

    setState(() => isLoading = true);

    try {
      final dataModel = ScreeningData()
        ..fullName = namalengkapcontroller.text.trim()
        ..gender = selectedGender
        ..birthDate = selectedDate // Simpan objek DateTime
        ..schoolClass = sekolahkelascontroller.text.trim()
        ..address = alamatcontroller.text.trim()
        ..parentName = ortuwalicontroller.text.trim()
        ..contactNumber = kontakcontroller.text.trim();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Antropometri(gender: dataModel.gender!, initialData: dataModel),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan identitas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- LOGIKA DATE PICKER DAN HITUNG USIA ---
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 17)),
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked; // Simpan objek DateTime

        // Format tampilan di TextField
        final formattedDisplayDate = DateFormat('d MMMM yyyy').format(picked);
        tanggallahircontroller.text = formattedDisplayDate;

        // Hitung Usia
        int age = now.year - picked.year;
        if (now.month < picked.month ||
            (now.month == picked.month && now.day < picked.day)) {
          age--;
        }
        usiacontroller.text = '$age Tahun';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Data Identitas Remaja",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Lengkap",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: namalengkapcontroller,
                label: 'Nama Lengkap',
                hintText: "Masukkan Nama Lengkap",
              ),
              SizedBox(height: 12),
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Laki - Laki',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: 'laki',
                      groupValue: selectedGender,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Perempuan',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: 'perempuan',
                      groupValue: selectedGender,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                "Tanggal Lahir",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: tanggallahircontroller,
                label: 'Tanggal Lahir',
                readOnly: true,
                suffixIcon: Icons.calendar_today,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 12),
              Text(
                "Usia",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              IgnorePointer(
                child: Formscreening(
                  controller: usiacontroller,
                  label: 'Usia',
                  readOnly: true,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Sekolah / Kelas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: sekolahkelascontroller,
                label: 'Sekolah / Kelas',
                hintText: "Masukkan Sekolah / Kelas",
              ),
              SizedBox(height: 12),
              Text(
                "Alamat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: alamatcontroller,
                label: 'Alamat',
                hintText: "Masukkan Alamat",
              ),
              SizedBox(height: 12),
              Text(
                "Nama Orangtua / Wali",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: ortuwalicontroller,
                label: 'Nama Orangtua / Wali',
                hintText: "Masukkan Nama Orangtua / Wali",
              ),
              SizedBox(height: 12),
              Text(
                "Nomor Kontak",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: kontakcontroller,
                keyboardType: TextInputType.number,
                inputFormatters: AppInputFormatters.digitsOnly,
                label: 'Nomor Kontak',
                hintText: "Masukkan Nomor Kontak",
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(400, 48)),
                  onPressed: isLoading ? null : _collectAndContinue,
                  child: Text(
                    "Next",
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
