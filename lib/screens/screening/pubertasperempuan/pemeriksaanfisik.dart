import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertasperempuan.dart';

class PemeriksaanFisik extends StatefulWidget {
  const PemeriksaanFisik({super.key});

  @override
  State<PemeriksaanFisik> createState() => _PemeriksaanFisikState();
}

class _PemeriksaanFisikState extends State<PemeriksaanFisik> {
  String? selectedKulitBerjerawat;
  String? selectedPayudaraSimetris;
  String? selectedBenjolanPayudara;
  String? selectedRambutRontok;

  final List<String> opsiYaTidak = ['Ya', 'Tidak'];

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Pemeriksaan Fisik",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Kulit Berjerawat",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.kulitBerjerawatController,
          label: 'Kulit Berjerawat',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Kulit Berjerawat?',
              options: opsiYaTidak,
              controller: PubertasControllers.kulitBerjerawatController,
              onSelected: (value) {
                selectedKulitBerjerawat = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Payudara Simetris",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.payudaraSimetrisController,
          label: 'Payudara Simetris',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Payudara Simetris?',
              options: opsiYaTidak,
              controller: PubertasControllers.payudaraSimetrisController,
              onSelected: (value) {
                selectedPayudaraSimetris = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Benjolan Payudara",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.benjolanPayudaraController,
          label: 'Benjolan Payudara',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Benjolan Payudara?',
              options: opsiYaTidak,
              controller: PubertasControllers.benjolanPayudaraController,
              onSelected: (value) {
                selectedBenjolanPayudara = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Rambut Rontok",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.rambutRontokController,
          label: 'Rambut Rontok',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Rambut Rontok?',
              options: opsiYaTidak,
              controller: PubertasControllers.rambutRontokController,
              onSelected: (value) {
                selectedRambutRontok = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
