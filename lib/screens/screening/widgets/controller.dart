import 'package:flutter/material.dart';

//remaja
final TextEditingController namalengkapcontroller = TextEditingController();
final TextEditingController tanggallahircontroller = TextEditingController();
final TextEditingController usiacontroller = TextEditingController();
final TextEditingController sekolahkelascontroller = TextEditingController();
final TextEditingController alamatcontroller = TextEditingController();
final TextEditingController ortuwalicontroller = TextEditingController();
final TextEditingController kontakcontroller = TextEditingController();

//antropometri
final TextEditingController tinggicontroller = TextEditingController();
final TextEditingController beratcontroller = TextEditingController();
final TextEditingController imtcontroller = TextEditingController();
final TextEditingController statusgizicontroller = TextEditingController();
final TextEditingController pertumbuhancontroller = TextEditingController();
final TextEditingController lingkarpinggangcontroller = TextEditingController();
final TextEditingController darahcontroller = TextEditingController();
final TextEditingController denyutcontroller = TextEditingController();
final TextEditingController kroniscontroller = TextEditingController();

//perempuan
final TextEditingController payudaraController = TextEditingController();
final TextEditingController rambutKemaluanController = TextEditingController();
final TextEditingController rambutKetiakController = TextEditingController();
final TextEditingController menarcheController = TextEditingController();
final TextEditingController usiaMenarcheController = TextEditingController();
final TextEditingController siklusHaidController = TextEditingController();
final TextEditingController lamaHaidController = TextEditingController();
final TextEditingController volumeHaidController = TextEditingController();
final TextEditingController nyeriHaidController = TextEditingController();
final TextEditingController keputihanController =
    TextEditingController(); // Added for Keputihan
final TextEditingController kulitBerjerawatController = TextEditingController();
final TextEditingController payudaraSimetrisController =
    TextEditingController();
final TextEditingController benjolanPayudaraController =
    TextEditingController();
final TextEditingController rambutRontokController = TextEditingController();

String? selectedPayudara;
String? selectedRambutKemaluan;
String? selectedRambutKetiak;
String? selectedMenarche;
String? selectedSiklusHaid;
String? selectedVolumeHaid;
String? selectedNyeriHaid;
String? selectedKeputihan; // Added for Keputihan
String? selectedKulitBerjerawat;
String? selectedPayudaraSimetris;
String? selectedBenjolanPayudara;
String? selectedRambutRontok;

final List<String> tahapPayudara = ['M1', 'M2', 'M3', 'M4', 'M5'];
final List<String> tahapRambutKemaluan = ['P1', 'P2', 'P3', 'P4', 'P5'];
final List<String> opsiRambutKetiak = ['Ya', 'Tidak'];
final List<String> opsiMenarche = ['Ya', 'Tidak'];
final List<String> opsiYaTidak = ['Ya', 'Tidak'];
final List<String> opsiSiklusHaid = ['Teratur', 'Tidak Teratur'];
final List<String> opsiVolumeHaid = ['Sedikit', 'Normal', 'Banyak'];
final List<String> opsiNyeriHaid = ['Tidak Ada', 'Ringan', 'Sedang', 'Berat'];
final List<String> opsiKeputihan = ['Tidak Ada', 'Normal', 'Abnormal'];
