import 'dart:math';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nursecycle/models/screening_data.dart';
import 'seksualsekunderlaki.dart';
import 'pemeriksaanfisikreproduksi.dart';
import 'perubahanfisiologis.dart';
import 'psikologissosiallaki.dart';

class PubertasLakiControllers {
  static final TextEditingController ukuranTestisController =
      TextEditingController();
  static final TextEditingController rambutKemaluanController =
      TextEditingController();
  static final TextEditingController rambutKetiakController =
      TextEditingController();
  static final TextEditingController perubahanSuaraController =
      TextEditingController();
  static final TextEditingController pertumbuhanKumisController =
      TextEditingController();
  static final TextEditingController testisSimetrisController =
      TextEditingController();
  static final TextEditingController testisTurunController =
      TextEditingController();
  static final TextEditingController ginekomastiaController =
      TextEditingController();
  static final TextEditingController jerawatController =
      TextEditingController();
  static final TextEditingController pertumbuhanCepatController =
      TextEditingController();
  static final TextEditingController nafsuMakanController =
      TextEditingController();
  static final TextEditingController mimpiBasahController =
      TextEditingController();
  static final TextEditingController perubahanTidurController =
      TextEditingController();
  static final TextEditingController emosiSulitController =
      TextEditingController();
  static final TextEditingController perilakuAgresifController =
      TextEditingController();
  static final TextEditingController masalahPercayaDiriController =
      TextEditingController();
  static final TextEditingController ketertarikanLawanJenisController =
      TextEditingController();
  static final TextEditingController riwayatStresController =
      TextEditingController();
}

class Pubertaslaki extends StatefulWidget {
  final ScreeningData screeningData;

  const Pubertaslaki({super.key, required this.screeningData});

  @override
  State<Pubertaslaki> createState() => _PubertaslakiState();
}

class _PubertaslakiState extends State<Pubertaslaki> {
  String? selectedUkuranTestis;
  String? selectedRambutKemaluan;
  String? selectedRambutKetiak;
  String? selectedPerubahanSuara;
  String? selectedPertumbuhanKumis;
  String? selectedTestisSimetris;
  String? selectedTestisTurun;
  String? selectedGinekomastia;
  String? selectedJerawat;
  String? selectedPertumbuhanCepat;
  String? selectedNafsuMakan;
  String? selectedMimpiBasah;
  String? selectedPerubahanTidur;
  String? selectedEmosiSulit;
  String? selectedPerilakuAgresif;
  String? selectedMasalahPercayaDiri;
  String? selectedKetertarikanLawanJenis;
  String? selectedRiwayatStres;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    PubertasLakiControllers.ukuranTestisController.text =
        selectedUkuranTestis ?? '';
    PubertasLakiControllers.rambutKemaluanController.text =
        selectedRambutKemaluan ?? '';
    PubertasLakiControllers.rambutKetiakController.text =
        selectedRambutKetiak ?? '';
    PubertasLakiControllers.perubahanSuaraController.text =
        selectedPerubahanSuara ?? '';
    PubertasLakiControllers.pertumbuhanKumisController.text =
        selectedPertumbuhanKumis ?? '';
    PubertasLakiControllers.testisSimetrisController.text =
        selectedTestisSimetris ?? '';
    PubertasLakiControllers.testisTurunController.text =
        selectedTestisTurun ?? '';
    PubertasLakiControllers.ginekomastiaController.text =
        selectedGinekomastia ?? '';
    PubertasLakiControllers.jerawatController.text = selectedJerawat ?? '';
    PubertasLakiControllers.pertumbuhanCepatController.text =
        selectedPertumbuhanCepat ?? '';
    PubertasLakiControllers.nafsuMakanController.text =
        selectedNafsuMakan ?? '';
    PubertasLakiControllers.mimpiBasahController.text =
        selectedMimpiBasah ?? '';
    PubertasLakiControllers.perubahanTidurController.text =
        selectedPerubahanTidur ?? '';
    PubertasLakiControllers.emosiSulitController.text =
        selectedEmosiSulit ?? '';
    PubertasLakiControllers.perilakuAgresifController.text =
        selectedPerilakuAgresif ?? '';
    PubertasLakiControllers.masalahPercayaDiriController.text =
        selectedMasalahPercayaDiri ?? '';
    PubertasLakiControllers.ketertarikanLawanJenisController.text =
        selectedKetertarikanLawanJenis ?? '';
    PubertasLakiControllers.riwayatStresController.text =
        selectedRiwayatStres ?? '';
  }

  Future<void> _finalSubmit() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Anda harus login untuk menyimpan data.')));
      return;
    }

    // 1. KUMPULKAN SEMUA DATA DARI CONTROLLER KE MODEL
    _collectDataFromControllers();

    setState(() => _isSubmitting = true);
    final String screeningNumber =
        'SCR-${DateFormat('yyyyMMdd').format(DateTime.now())}-${Random().nextInt(9999)}';

    try {
      // --- MULTI-TABLE INSERT TRANSACTION (POIN 1-2 & 4) ---

      // 1. DATA IDENTITAS (screening_identity)
      await Supabase.instance.client.from('screening_identity').insert({
        'user_id': user.id,
        'screening_number': screeningNumber,
        'full_name': widget.screeningData.fullName,
        'gender': widget.screeningData.gender,
        'birth_date':
            DateFormat('yyyy-MM-dd').format(widget.screeningData.birthDate!),
        'school_class': widget.screeningData.schoolClass,
        'address': widget.screeningData.address,
        'parent_name': widget.screeningData.parentName,
        'contact_number': widget.screeningData.contactNumber,
      });

      // 2. DATA ANTROPOMETRI (screening_antropometri)
      await Supabase.instance.client.from('screening_antropometri').insert({
        'user_id': user.id,
        'height_cm': widget.screeningData.heightCm,
        'weight_kg': widget.screeningData.weightKg,
        'imt': widget.screeningData.imt,
        'status_gizi': widget.screeningData.statusGizi,
        'growth_speed': widget.screeningData.growthSpeed,
        'waist_circ_cm': widget.screeningData.waistCircCm,
        'pulse_rate': widget.screeningData.pulseRate,
        'chronic_disease': widget.screeningData.chronicDisease,
        'blood_pressure':
            '${widget.screeningData.systolicBp}/${widget.screeningData.diastolicBp}', // Disimpan sebagai TEXT
      });

      // 3. SEKSUAL SEKUNDER (screening_puberty_male_tanner)
      await Supabase.instance.client
          .from('screening_puberty_male_tanner')
          .insert({
        'user_id': user.id,
        'tanner_testis': widget.screeningData.tannerTestis,
        'tanner_pubic_hair': widget.screeningData.tannerPubicHairMale,
        'axillary_hair': widget.screeningData.axillaryHairMale,
        'voice_change': widget.screeningData.voiceChange,
        'beard_growth': widget.screeningData.beardGrowth,
      });

      // 4. FISIK & FISIOLOGIS (screening_puberty_male_fisik)
      await Supabase.instance.client
          .from('screening_puberty_male_fisik')
          .insert({
        'user_id': user.id,
        'testis_symmetric': widget.screeningData.testisSymmetric,
        'testis_descended': widget.screeningData.testisDescended,
        'gynecomastia': widget.screeningData.gynecomastia,
        'acne': widget.screeningData.acneMale,
        'growth_spurt': widget.screeningData.growthSpurtMale,
        'appetite_increased': widget.screeningData.appetiteIncreased,
        'wet_dreams': widget.screeningData.wetDreams,
        'sleep_change': widget.screeningData.sleepChangeMale,
      });

      // 5. PSIKOSOSIAL (screening_puberty_male_psikososial)
      await Supabase.instance.client
          .from('screening_puberty_male_psikososial')
          .insert({
        'user_id': user.id,
        'emotion_uncontrolled': widget.screeningData.emotionUncontrolled,
        'aggressive_lonely': widget.screeningData.aggressiveLonely,
        'self_confidence_issue': widget.screeningData.selfConfidenceIssue,
        'opposite_sex_interest': widget.screeningData.oppositeSexInterest,
        'stress_history': widget.screeningData.stressHistoryMale,
      });

      // SUKSES
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Screening Lengkap berhasil disimpan!'),
              backgroundColor: Colors.green),
        );
        // Kembali ke halaman utama atau dashboard
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan total screening: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _collectDataFromControllers() {
    // 1. Seksual Sekunder
    widget.screeningData.tannerTestis =
        PubertasLakiControllers.ukuranTestisController.text;
    widget.screeningData.tannerPubicHairMale =
        PubertasLakiControllers.rambutKemaluanController.text;
    widget.screeningData.axillaryHairMale =
        PubertasLakiControllers.rambutKetiakController.text == 'Ya';
    widget.screeningData.voiceChange =
        PubertasLakiControllers.perubahanSuaraController.text == 'Ya';
    widget.screeningData.beardGrowth =
        PubertasLakiControllers.pertumbuhanKumisController.text == 'Ya';

    // 2. Pemeriksaan Fisik Reproduksi
    widget.screeningData.testisSymmetric =
        PubertasLakiControllers.testisSimetrisController.text == 'Ya';
    widget.screeningData.testisDescended =
        PubertasLakiControllers.testisTurunController.text == 'Ya';
    widget.screeningData.gynecomastia =
        PubertasLakiControllers.ginekomastiaController.text == 'Ya';
    widget.screeningData.acneMale =
        PubertasLakiControllers.jerawatController.text == 'Ya';
    widget.screeningData.growthSpurtMale =
        PubertasLakiControllers.pertumbuhanCepatController.text == 'Ya';

    // 3. Perubahan Fisiologis
    widget.screeningData.appetiteIncreased =
        PubertasLakiControllers.nafsuMakanController.text == 'Ya';
    widget.screeningData.wetDreams =
        PubertasLakiControllers.mimpiBasahController.text == 'Ya';
    widget.screeningData.sleepChangeMale =
        PubertasLakiControllers.perubahanTidurController.text == 'Ya';

    // 4. Psikologis dan Sosial
    widget.screeningData.emotionUncontrolled =
        PubertasLakiControllers.emosiSulitController.text == 'Ya';
    widget.screeningData.aggressiveLonely = PubertasLakiControllers
        .perilakuAgresifController.text; // Note: Ini Text
    widget.screeningData.selfConfidenceIssue =
        PubertasLakiControllers.masalahPercayaDiriController.text == 'Ya';
    widget.screeningData.oppositeSexInterest =
        PubertasLakiControllers.ketertarikanLawanJenisController.text == 'Ya';
    widget.screeningData.stressHistoryMale =
        PubertasLakiControllers.riwayatStresController.text; // Note: Ini Text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Perkembangan Pubertas – Laki-Laki',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SeksualSekunderLaki(),
            PemeriksaanFisikReproduksi(),
            PerubahanFisiologis(),
            PsikologisSosialLaki(),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _finalSubmit,
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
