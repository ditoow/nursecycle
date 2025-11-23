import 'package:flutter/material.dart';
import 'package:nursecycle/core/inputformat.dart';
import 'package:nursecycle/models/screening_data.dart';
import 'package:nursecycle/screens/screening/pubertasperempuan/pubertasperempuan.dart';
import 'package:nursecycle/screens/screening/pubertaslaki/pubertaslaki.dart';
import 'package:nursecycle/screens/screening/widgets/formscreening.dart';

final TextEditingController tinggicontroller = TextEditingController();
final TextEditingController beratcontroller = TextEditingController();
final TextEditingController imtcontroller = TextEditingController();
final TextEditingController statusgizicontroller = TextEditingController();
final TextEditingController pertumbuhancontroller = TextEditingController();
final TextEditingController lingkarpinggangcontroller = TextEditingController();
final TextEditingController darahcontroller = TextEditingController();
final TextEditingController denyutcontroller = TextEditingController();
final TextEditingController kroniscontroller = TextEditingController();

class Antropometri extends StatefulWidget {
  final String gender;
  final ScreeningData initialData;

  const Antropometri(
      {super.key, required this.gender, required this.initialData});

  @override
  State<Antropometri> createState() => _AntropometriState();
}

class _AntropometriState extends State<Antropometri> {
  late final TextEditingController tinggicontroller;
  late final TextEditingController beratcontroller;
  late final TextEditingController imtcontroller;
  late final TextEditingController statusgizicontroller;
  late final TextEditingController pertumbuhancontroller;
  late final TextEditingController lingkarpinggangcontroller;
  late final TextEditingController darahcontroller;
  late final TextEditingController denyutcontroller;
  late final TextEditingController kroniscontroller;

  bool isLoading = false;

  String kategoriimt = "";

  void _hitungIMT() {
    final double berat = double.tryParse(beratcontroller.text) ?? 0;
    final double tinggiCm = double.tryParse(tinggicontroller.text) ?? 0;

    if (berat > 0 && tinggiCm > 0) {
      final double tinggiMeter = tinggiCm / 100;
      final double imt = berat / (tinggiMeter * tinggiMeter);

      String kategoriHasil;
      if (imt < 18.5) {
        kategoriHasil = "Kurus";
      } else if (imt >= 18.5 && imt <= 24.9) {
        kategoriHasil = "Normal";
      } else if (imt >= 25 && imt <= 29.9) {
        kategoriHasil = "Gemuk";
      } else {
        kategoriHasil = "Obesitas";
      }
      setState(() {
        imtcontroller.text = imt.toStringAsFixed(2);
        statusgizicontroller.text = kategoriHasil;
      });
    } else {
      setState(() {
        imtcontroller.text = "";
        statusgizicontroller.text = "";
      });
    }
  }

  @override
  void initState() {
    tinggicontroller = TextEditingController();
    beratcontroller = TextEditingController();
    imtcontroller = TextEditingController();
    statusgizicontroller = TextEditingController();
    pertumbuhancontroller = TextEditingController();
    lingkarpinggangcontroller = TextEditingController();
    darahcontroller = TextEditingController();
    denyutcontroller = TextEditingController();
    kroniscontroller = TextEditingController();

    super.initState();
    tinggicontroller.addListener(_hitungIMT);
    beratcontroller.addListener(_hitungIMT);
  }

  @override
  void dispose() {
    tinggicontroller.dispose();
    beratcontroller.dispose();
    imtcontroller.dispose();
    statusgizicontroller.dispose();
    pertumbuhancontroller.dispose();
    lingkarpinggangcontroller.dispose();
    darahcontroller.dispose();
    denyutcontroller.dispose();
    kroniscontroller.dispose();
    super.dispose();
  }

  Future<void> _collectAndContinue() async {
    // 1. Validasi Input Wajib (Cek Tinggi dan Berat)
    if (tinggicontroller.text.isEmpty || beratcontroller.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tinggi dan Berat Badan wajib diisi.')),
        );
      }
      return;
    }

    setState(() => isLoading = true);

    try {
      // --- PRE-PROCESSING DATA ---
      _hitungIMT(); // Pastikan IMT & Status Gizi sudah dihitung

      final String tekananDarah = darahcontroller.text.trim();

      // Penanganan Tekanan Darah (Split untuk disimpan ke Model)
      int systolic = int.tryParse(tekananDarah.split('/').first.trim()) ?? 0;
      int diastolic = int.tryParse(tekananDarah.split('/').last.trim()) ?? 0;

      // TIDAK ADA LAGI user.id atau tabelFisik di sini, karena belum disimpan.
      // --------------------------

      // ✅ PENGGANTI DUAL-INSERT: UPDATE MODEL SCREENINGDATA
      widget.initialData
        ..heightCm = double.tryParse(tinggicontroller.text.trim())
        ..weightKg = double.tryParse(beratcontroller.text.trim())
        ..imt = double.tryParse(imtcontroller.text.trim())
        ..statusGizi = statusgizicontroller.text.trim()
        ..growthSpeed = double.tryParse(pertumbuhancontroller.text.trim())
        ..waistCircCm = double.tryParse(lingkarpinggangcontroller.text.trim())
        ..pulseRate = int.tryParse(denyutcontroller.text.trim())

        // Data Fisik Vital Sign
        ..systolicBp = systolic
        ..diastolicBp = diastolic
        ..chronicDisease = kroniscontroller.text.trim();

      // TIDAK ADA PANGGILAN SUPABASE INSERT DI SINI

      // --- NAVIGASI DAN SUKSES ---
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Data Antropometri terkumpul di memori.'),
              backgroundColor:
                  Colors.blueGrey // Warna berbeda karena belum save ke DB
              ),
        );

        // Lanjutkan ke halaman pubertas sambil membawa model yang SUDAH TERISI
        if (widget.gender == 'laki') {
          // Catatan: Pubertaslaki harus diupdate untuk menerima 'screeningData'
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Pubertaslaki(screeningData: widget.initialData),
            ),
          );
        } else {
          // Catatan: Pubertasperempuan harus diupdate untuk menerima 'screeningData'
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Pubertasperempuan(screeningData: widget.initialData),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memproses data. Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // TIDAK PERLU CEK USER ID
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Data Pemeriksaan Antropometri",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tinggi Badan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: tinggicontroller,
                label: 'Tinggi Badan',
                hintText: 'Masukkan Tinggi Badan',
                keyboardType: TextInputType.number,
                inputFormatters: AppInputFormatters.digitsOnly,
                suffix: 'cm',
              ),
              SizedBox(height: 12),
              Text(
                "Berat Badan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: beratcontroller,
                label: 'Berat Badan',
                hintText: "Masukkan Berat Badan",
                suffix: 'kg',
                keyboardType: TextInputType.number,
                inputFormatters: AppInputFormatters.digitsOnly,
              ),
              SizedBox(height: 12),
              Text(
                "IMT",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              IgnorePointer(
                child: Formscreening(
                  controller: imtcontroller,
                  label: 'IMT',
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Status Gizi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              IgnorePointer(
                child: Formscreening(
                  controller: statusgizicontroller,
                  label: 'Status Gizi',
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Kecepatan Pertumbuhan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: pertumbuhancontroller,
                label: 'Kecepatan Pertumbuhan',
              ),
              SizedBox(height: 12),
              Text(
                "Lingkar Pinggang",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: lingkarpinggangcontroller,
                label: 'Lingkar Pinggang',
                hintText: 'Masukkan Lingkar Pinggang',
                suffix: 'cm',
              ),
              SizedBox(height: 12),
              Text(
                "Tekanan Darah",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: darahcontroller,
                label: 'Tekanan Darah',
                hintText: 'Masukkan Sistolik/Diastolik (e.g., 120/80)',
                keyboardType: TextInputType.text,
                suffix: 'mmHg',
              ),
              SizedBox(height: 12),
              Text(
                "Denyut Nadi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: denyutcontroller,
                label: 'Denyut Nadi',
                hintText: 'Masukkan Denyut Nadi',
                keyboardType: TextInputType.number,
                inputFormatters: AppInputFormatters.digitsOnly,
                suffix: 'bpm',
              ),
              SizedBox(height: 12),
              Text(
                "Riwayat Penyakit Kronis",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: kroniscontroller,
                label: 'Riwayat Penyakit Kronis',
                hintText: 'Masukkan Riwayat Penyakit Kronis',
                suffix: 'bpm',
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
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
