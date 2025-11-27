class ScreeningData {
  String? fullName;
  String? gender;
  DateTime? birthDate;
  String? schoolClass;
  String? address;
  String? parentName;
  String? contactNumber;

  double? heightCm;
  double? weightKg;
  double? imt;
  String? statusGizi;
  double? growthSpeed;
  double? waistCircCm;

  int? systolicBp;
  int? diastolicBp;
  int? pulseRate;
  String? chronicDisease;

  String? tannerTestis;
  String? tannerPubicHairMale;
  bool? axillaryHairMale;
  bool? voiceChange;
  bool? beardGrowth;

  bool? testisSymmetric;
  bool? testisDescended;
  bool? gynecomastia;
  bool? acneMale;
  bool? growthSpurtMale;

  bool? appetiteIncreased;
  bool? wetDreams;
  bool? sleepChangeMale;

  bool? emotionUncontrolled;
  String? aggressiveLonely;
  bool? selfConfidenceIssue;
  bool? oppositeSexInterest;
  String? stressHistoryMale;

  // 3.A Tanda Seksual Sekunder
  String? tannerBreasts; // Tahap Pertumbuhan Payudara (M1-M5)
  String? tannerPubicHairFemale; // Tahap Rambut Kemaluan (P1-P5)
  bool? axillaryHairFemale; // Rambut Ketiak

  // 3.B Menstruasi & Kebersihan
  bool? menarche; // Sudah Menarche
  int? menarcheAge; // Usia Menarche
  String? cycleRegularity; // Siklus Haid (Teratur/Tidak Teratur)
  int? periodDuration; // Lama Haid (hari)
  String? periodVolume; // Volume Haid
  String? painLevel; // Nyeri Haid
  String? leucorrheaStatus; // Keputihan
  bool? hygieneEducationReceived; // Edukasi kebersihan haid diterima
  bool? padChangingHabit; // Kebiasaan ganti pembalut benar

  // 3.C/D Fisik & Psikososial
  bool? acneFemale; // Kulit berjerawat
  bool? breastSymmetry; // Payudara simetris
  bool? breastLump; // Benjolan payudara
  bool? hairLoss; // Rambut rontok
  bool? emotionChangeOften; // Perubahan emosi sering
  bool? negativeBodyImage; // Citra tubuh negatif
  bool? socialWithdrawal; // Menarik diri dari teman
  String? stressHistoryFemale; // Riwayat stres (Tidak/Pernah/Sedang)
  bool? sleepDisturbance; // Pola tidur terganggu

  bool isGlobalDataLoaded = false;

  ScreeningData();

  @override
  String toString() {
    return 'ScreeningData(fullName: $fullName, gender: $gender, imt: $imt, bp: $systolicBp/$diastolicBp)';
  }
}
