import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nursecycle/screens/screening/widgets/controller.dart';
import 'package:nursecycle/screens/screening/widgets/formscreening.dart';
import 'package:nursecycle/screens/screening/widgets/menarche_fields.dart';

class Pubertasperempuan extends StatefulWidget {
  const Pubertasperempuan({super.key});

  @override
  State<Pubertasperempuan> createState() => _PubertasperempuanState();
}

class _PubertasperempuanState extends State<Pubertasperempuan> {
  @override
  void initState() {
    super.initState();
    // Set nilai awal controller jika sudah ada data
    payudaraController.text = selectedPayudara ?? '';
    rambutKemaluanController.text = selectedRambutKemaluan ?? '';
    rambutKetiakController.text = selectedRambutKetiak ?? '';
    menarcheController.text = selectedMenarche ?? '';
    siklusHaidController.text = selectedSiklusHaid ?? '';
    volumeHaidController.text = selectedVolumeHaid ?? '';
    nyeriHaidController.text = selectedNyeriHaid ?? '';
    kulitBerjerawatController.text = selectedKulitBerjerawat ?? '';
    payudaraSimetrisController.text = selectedPayudaraSimetris ?? '';
    benjolanPayudaraController.text = selectedBenjolanPayudara ?? '';
    rambutRontokController.text = selectedRambutRontok ?? '';
  }

  void _showSelectionDialog({
    required String title,
    required List<String> options,
    required TextEditingController controller,
    required Function(String) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      onSelected(option);
                      controller.text = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
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
            Align(
              alignment: Alignment.center,
              child: Text(
                "Tanda Seksual Sekunder",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),

            SizedBox(height: 18),
            // Tahap Pertumbuhan Payudara
            Text(
              "Tahap Pertumbuhan Payudara",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Formscreening(
              controller: payudaraController,
              label: 'Tahap Pertumbuhan Payudara (M1-M5)',
              hintText: 'Pilih Tahap Payudara',
              readOnly: true,
              onTap: () {
                _showSelectionDialog(
                  title: 'Pilih Tahap Payudara',
                  options: tahapPayudara,
                  controller: payudaraController,
                  onSelected: (value) {
                    selectedPayudara = value;
                  },
                );
              },
              suffixIcon: Icons.arrow_drop_down,
            ),
            SizedBox(height: 20),

            // Tahap Rambut Kemaluan
            Text(
              "Tahap Rambut Kemaluan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Formscreening(
              controller: rambutKemaluanController,
              label: 'Tahap Rambut Kemaluan (P1-P5)',
              hintText: 'Pilih Tahap Rambut Kemaluan',
              readOnly: true,
              onTap: () {
                _showSelectionDialog(
                  title: 'Pilih Tahap Rambut Kemaluan',
                  options: tahapRambutKemaluan,
                  controller: rambutKemaluanController,
                  onSelected: (value) {
                    selectedRambutKemaluan = value;
                  },
                );
              },
              suffixIcon: Icons.arrow_drop_down,
            ),
            SizedBox(height: 20),

            // Rambut Ketiak
            Text(
              "Rambut Ketiak",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Formscreening(
              controller: rambutKetiakController,
              label: 'Rambut Ketiak',
              hintText: 'Pilih Ya/Tidak',
              readOnly: true,
              onTap: () {
                _showSelectionDialog(
                  title: 'Pilih Rambut Ketiak',
                  options: opsiRambutKetiak,
                  controller: rambutKetiakController,
                  onSelected: (value) {
                    selectedRambutKetiak = value;
                  },
                );
              },
              suffixIcon: Icons.arrow_drop_down,
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Menstruasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12),
            // Sudah Menarche
            Text(
              "Sudah Menarche",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Formscreening(
              controller: menarcheController,
              label: 'Sudah Menarche',
              hintText: 'Pilih Ya/Tidak',
              readOnly: true,
              onTap: () {
                _showSelectionDialog(
                  title: 'Sudah Menarche?',
                  options: opsiMenarche,
                  controller: menarcheController,
                  onSelected: (value) {
                    selectedMenarche = value;
                    // Reset field lain jika pilih "Tidak"
                    if (value == 'Tidak') {
                      usiaMenarcheController.clear();
                      siklusHaidController.clear();
                      lamaHaidController.clear();
                      volumeHaidController.clear();
                      nyeriHaidController.clear();
                      keputihanController.clear();
                      selectedSiklusHaid = null;
                      selectedVolumeHaid = null;
                      selectedNyeriHaid = null;
                      selectedKeputihan = null;
                    }
                  },
                );
              },
              suffixIcon: Icons.arrow_drop_down,
            ),
            SizedBox(height: 20),

            // Field berikut hanya muncul jika sudah menarche
            if (selectedMenarche == 'Ya')
              MenarcheFields(
                usiaMenarcheController: usiaMenarcheController,
                siklusHaidController: siklusHaidController,
                lamaHaidController: lamaHaidController,
                volumeHaidController: volumeHaidController,
                nyeriHaidController: nyeriHaidController,
                keputihanController: keputihanController,
                kulitBerjerawatController: kulitBerjerawatController,
                payudaraSimetrisController: payudaraSimetrisController,
                benjolanPayudaraController: benjolanPayudaraController,
                rambutRontokController: rambutRontokController,
              ),

            SizedBox(height: 30),

            // Tombol Simpan (opsional)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ))
                },
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
