import 'package:flutter/material.dart';
import 'package:nursecycle/core/inputformat.dart';
import 'package:nursecycle/screens/screening/pubertasperempuan.dart';
import 'package:nursecycle/screens/screening/widgets/controller.dart';
import 'package:nursecycle/screens/screening/widgets/formscreening.dart';

class Antropometri extends StatefulWidget {
  const Antropometri({super.key});

  @override
  State<Antropometri> createState() => _AntropometriState();
}

class _AntropometriState extends State<Antropometri> {
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
    super.initState();

    tinggicontroller.addListener(_hitungIMT);
    beratcontroller.addListener(_hitungIMT);
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
              //tinggibadan
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
              //tinggibadan
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
              //imt
              SizedBox(height: 12),
              //imt
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
              //status
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
              //kecepatan pertumbuhan
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
              //lingkar pinggang
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
              //tekanan darah
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
                hintText: 'Masukkan Tekanan Darah',
                keyboardType: TextInputType.number,
                inputFormatters: AppInputFormatters.digitsOnly,
                suffix: 'mmHg',
              ),
              SizedBox(height: 12),
              //denyut nadi
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
              //Riwayat Penyakit Kronis
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pubertasperempuan(),
                      ),
                    );
                  },
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
