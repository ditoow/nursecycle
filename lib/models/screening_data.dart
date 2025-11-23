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

  ScreeningData();

  @override
  String toString() {
    return 'ScreeningData(fullName: $fullName, gender: $gender, imt: $imt, bp: $systolicBp/$diastolicBp)';
  }
}
