import 'package:flutter/material.dart';
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
  const Pubertaslaki({super.key});

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
