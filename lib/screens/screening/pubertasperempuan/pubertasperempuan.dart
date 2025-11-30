import 'dart:math';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nursecycle/models/screening_data.dart';
import 'seksualsekunder.dart';
import 'menstruasi.dart';

class PubertasControllers {
  static final TextEditingController payudaraController =
      TextEditingController();
  static final TextEditingController rambutKemaluanController =
      TextEditingController();
  static final TextEditingController rambutKetiakController =
      TextEditingController();
  static final TextEditingController menarcheController =
      TextEditingController();
  static final TextEditingController usiaMenarcheController =
      TextEditingController();
  static final TextEditingController siklusHaidController =
      TextEditingController();
  static final TextEditingController lamaHaidController =
      TextEditingController();
  static final TextEditingController volumeHaidController =
      TextEditingController();
  static final TextEditingController nyeriHaidController =
      TextEditingController();
  static final TextEditingController keputihanController =
      TextEditingController();
  static final TextEditingController kulitBerjerawatController =
      TextEditingController();
  static final TextEditingController payudaraSimetrisController =
      TextEditingController();
  static final TextEditingController benjolanPayudaraController =
      TextEditingController();
  static final TextEditingController rambutRontokController =
      TextEditingController();
  static final TextEditingController polaTidurTergangguController =
      TextEditingController();
  static final TextEditingController riwayatStresController =
      TextEditingController();
  static final TextEditingController perubahanEmosiController =
      TextEditingController();
  static final TextEditingController citraTubuhNegatifController =
      TextEditingController();
  static final TextEditingController menarikDiriTemanController =
      TextEditingController();
  static final TextEditingController edukasiKebersihanHaidController =
      TextEditingController();
  static final TextEditingController kebiasaanGantiPembalutController =
      TextEditingController();
}

class Pubertasperempuan extends StatefulWidget {
  final ScreeningData screeningData;

  const Pubertasperempuan({super.key, required this.screeningData});

  @override
  State<Pubertasperempuan> createState() => _PubertasperempuanState();
}

class _PubertasperempuanState extends State<Pubertasperempuan> {
  String? selectedPayudara;
  String? selectedRambutKemaluan;
  String? selectedRambutKetiak;
  String? selectedMenarche;
  String? selectedSiklusHaid;
  String? selectedVolumeHaid;
  String? selectedNyeriHaid;
  String? selectedKeputihan;
  String? selectedKulitBerjerawat;
  String? selectedPayudaraSimetris;
  String? selectedBenjolanPayudara;
  String? selectedRambutRontok;
  String? selectedPolaTidurTerganggu;
  String? selectedRiwayatStres;
  String? selectedPerubahanEmosi;
  String? selectedCitraTubuhNegatif;
  String? selectedMenarikDiriTeman;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  void _collectDataFromControllers() {
    final data = widget.screeningData;

    // 1. Seksual Sekunder (Poin 3.A)
    data.tannerBreasts = PubertasControllers.payudaraController.text;
    data.tannerPubicHairFemale =
        PubertasControllers.rambutKemaluanController.text;
    data.axillaryHairFemale =
        PubertasControllers.rambutKetiakController.text == 'Ya';

    // 2. Menstruasi & Kebersihan (Poin 3.B & 3.E)
    data.menarche = PubertasControllers.menarcheController.text == 'Ya';
    data.menarcheAge =
        int.tryParse(PubertasControllers.usiaMenarcheController.text);
    data.cycleRegularity = PubertasControllers.siklusHaidController.text;
    data.periodDuration =
        int.tryParse(PubertasControllers.lamaHaidController.text);
    data.periodVolume = PubertasControllers.volumeHaidController.text;
    data.painLevel = PubertasControllers.nyeriHaidController.text;
    data.leucorrheaStatus = PubertasControllers.keputihanController.text;
    data.hygieneEducationReceived =
        PubertasControllers.edukasiKebersihanHaidController.text == 'Ya';
    data.padChangingHabit =
        PubertasControllers.kebiasaanGantiPembalutController.text == 'Ya';

    // 3. Fisik & Psikososial (Poin 3.C & 3.D)
    data.acneFemale =
        PubertasControllers.kulitBerjerawatController.text == 'Ya';
    data.breastSymmetry =
        PubertasControllers.payudaraSimetrisController.text == 'Ya';
    data.breastLump =
        PubertasControllers.benjolanPayudaraController.text == 'Ya';
    data.hairLoss = PubertasControllers.rambutRontokController.text == 'Ya';
    data.sleepDisturbance =
        PubertasControllers.polaTidurTergangguController.text == 'Ya';
    data.stressHistoryFemale = PubertasControllers.riwayatStresController.text;
    data.emotionChangeOften =
        PubertasControllers.perubahanEmosiController.text == 'Ya';
    data.negativeBodyImage =
        PubertasControllers.citraTubuhNegatifController.text == 'Ya';
    data.socialWithdrawal =
        PubertasControllers.menarikDiriTemanController.text == 'Ya';
  }

  Future<void> _finalSubmit() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sesi habis. Silakan login ulang.')));
      }
      return;
    }

    // 1. KUMPULKAN DATA TERAKHIR DARI SEMUA CONTROLLER
    _collectDataFromControllers();

    setState(() => _isSubmitting = true);
    final data = widget.screeningData;
    final String screeningNumber =
        'SCR-${DateFormat('yyyyMMdd').format(DateTime.now())}-${Random().nextInt(9999)}';

    try {
      // --- 1. DATA IDENTITAS (screening_identity) ---
      await Supabase.instance.client.from('screening_identity').insert({
        'user_id': user.id,
        'screening_number': screeningNumber,
        'full_name': data.fullName,
        'gender': data.gender,
        'birth_date': DateFormat('yyyy-MM-dd').format(data.birthDate!),
        'school_class': data.schoolClass,
        'address': data.address,
        'parent_name': data.parentName,
        'contact_number': data.contactNumber,
      });

      // --- 2. DATA ANTROPOMETRI (screening_antropometri) ---
      await Supabase.instance.client.from('screening_antropometri').insert({
        'user_id': user.id,
        'height_cm': data.heightCm,
        'weight_kg': data.weightKg,
        'imt': data.imt,
        'status_gizi': data.statusGizi,
        'growth_speed': data.growthSpeed,
        'waist_circ_cm': data.waistCircCm,
        'pulse_rate': data.pulseRate,
        'chronic_disease': data.chronicDisease,
        'blood_pressure': '${data.systolicBp}/${data.diastolicBp}',
      });

      // --- 3. SEKSUAL SEKUNDER (screening_puberty_female_tanner) ---
      await Supabase.instance.client
          .from('screening_puberty_female_tanner')
          .insert({
        'user_id': user.id,
        'tanner_breasts': data.tannerBreasts,
        'tanner_pubic_hair': data.tannerPubicHairFemale,
        'axillary_hair': data.axillaryHairFemale,
      });

      // --- 4. MENSTRUASI & KEBERSIHAN (screening_puberty_female_menstruasi) ---
      await Supabase.instance.client
          .from('screening_puberty_female_menstruasi')
          .insert({
        'user_id': user.id,
        'menarche': data.menarche,
        'menarche_age': data.menarcheAge,
        'cycle_regularity': data.cycleRegularity,
        'period_duration': data.periodDuration,
        'period_volume': data.periodVolume,
        'pain_level': data.painLevel,
        'leucorrhea_status': data.leucorrheaStatus,
        'hygiene_education_received': data.hygieneEducationReceived,
        'pad_changing_habit': data.padChangingHabit,
      });

      // --- 5. FISIK & PSIKOSOSIAL (screening_puberty_female_fisik) ---
      await Supabase.instance.client
          .from('screening_puberty_female_fisik')
          .insert({
        'user_id': user.id,
        'acne': data.acneFemale,
        'breast_symmetry': data.breastSymmetry,
        'breast_lump': data.breastLump,
        'hair_loss': data.hairLoss,
        'emotion_change_often': data.emotionChangeOften,
        'negative_body_image': data.negativeBodyImage,
        'social_withdrawal': data.socialWithdrawal,
        'stress_history': data.stressHistoryFemale,
        'sleep_disturbance': data.sleepDisturbance,
      });

      // SUKSES
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Screening Lengkap berhasil disimpan!'),
              backgroundColor: Colors.green),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Pubertas Perempuan',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SeksualSekunder(),
            Menstruasi(),
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
