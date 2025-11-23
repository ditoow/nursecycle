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

  @override
  void initState() {
    super.initState();

    PubertasControllers.payudaraController.text = selectedPayudara ?? '';
    PubertasControllers.rambutKemaluanController.text =
        selectedRambutKemaluan ?? '';
    PubertasControllers.rambutKetiakController.text =
        selectedRambutKetiak ?? '';
    PubertasControllers.menarcheController.text = selectedMenarche ?? '';
    PubertasControllers.siklusHaidController.text = selectedSiklusHaid ?? '';
    PubertasControllers.volumeHaidController.text = selectedVolumeHaid ?? '';
    PubertasControllers.nyeriHaidController.text = selectedNyeriHaid ?? '';
    PubertasControllers.kulitBerjerawatController.text =
        selectedKulitBerjerawat ?? '';
    PubertasControllers.payudaraSimetrisController.text =
        selectedPayudaraSimetris ?? '';
    PubertasControllers.benjolanPayudaraController.text =
        selectedBenjolanPayudara ?? '';
    PubertasControllers.rambutRontokController.text =
        selectedRambutRontok ?? '';
    PubertasControllers.polaTidurTergangguController.text =
        selectedPolaTidurTerganggu ?? '';
    PubertasControllers.riwayatStresController.text =
        selectedRiwayatStres ?? '';
    PubertasControllers.perubahanEmosiController.text =
        selectedPerubahanEmosi ?? '';
    PubertasControllers.citraTubuhNegatifController.text =
        selectedCitraTubuhNegatif ?? '';
    PubertasControllers.menarikDiriTemanController.text =
        selectedMenarikDiriTeman ?? '';
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
                onPressed: () {},
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
