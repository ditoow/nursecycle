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

  String selectedGender = 'laki'; // Diubah dari selectedRole ke selectedGender
  bool isLoading = false;

  DateTime? selectedDate;

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
