import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nursecycle/screens/screening/widgets/controller.dart';
import 'package:nursecycle/screens/screening/widgets/formscreening.dart';

class MenarcheFields extends StatefulWidget {
  final TextEditingController usiaMenarcheController;
  final TextEditingController siklusHaidController;
  final TextEditingController lamaHaidController;
  final TextEditingController volumeHaidController;
  final TextEditingController nyeriHaidController;
  final TextEditingController keputihanController;
  final TextEditingController kulitBerjerawatController;
  final TextEditingController payudaraSimetrisController;
  final TextEditingController benjolanPayudaraController;
  final TextEditingController rambutRontokController;

  const MenarcheFields({
    super.key,
    required this.usiaMenarcheController,
    required this.siklusHaidController,
    required this.lamaHaidController,
    required this.volumeHaidController,
    required this.nyeriHaidController,
    required this.keputihanController,
    required this.kulitBerjerawatController,
    required this.payudaraSimetrisController,
    required this.benjolanPayudaraController,
    required this.rambutRontokController,
  });

  @override
  State<MenarcheFields> createState() => _MenarcheFieldsState();
}

class _MenarcheFieldsState extends State<MenarcheFields> {
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
        // Usia Menarche
        Text(
          "Usia Menarche",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.usiaMenarcheController,
          label: 'Usia Menarche',
          hintText: 'Masukkan usia menarche',
          suffix: 'tahun',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
        ),
        SizedBox(height: 20),

        // Siklus Haid
        Text(
          "Siklus Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.siklusHaidController,
          label: 'Siklus Haid',
          hintText: 'Pilih siklus haid',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Siklus Haid',
              options: opsiSiklusHaid,
              controller: widget.siklusHaidController,
              onSelected: (value) {
                selectedSiklusHaid = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),

        // Lama Haid
        Text(
          "Lama Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.lamaHaidController,
          label: 'Lama Haid',
          hintText: 'Masukkan lama haid',
          suffix: 'hari',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
        ),
        SizedBox(height: 20),

        // Volume Haid
        Text(
          "Volume Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.volumeHaidController,
          label: 'Volume Haid',
          hintText: 'Pilih volume haid',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Volume Haid',
              options: opsiVolumeHaid,
              controller: widget.volumeHaidController,
              onSelected: (value) {
                selectedVolumeHaid = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),

        // Nyeri Haid
        Text(
          "Nyeri Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.nyeriHaidController,
          label: 'Nyeri Haid',
          hintText: 'Pilih tingkat nyeri haid',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Tingkat Nyeri Haid',
              options: opsiNyeriHaid,
              controller: widget.nyeriHaidController,
              onSelected: (value) {
                selectedNyeriHaid = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),

        // Keputihan
        Text(
          "Keputihan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.keputihanController,
          label: 'Keputihan',
          hintText: 'Pilih tingkat Keputihan',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Tingkat Keputihan',
              options: opsiKeputihan,
              controller: widget.keputihanController,
              onSelected: (value) {
                selectedKeputihan = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 24),
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
        // Kulit Berjerawat
        Text(
          "Kulit Berjerawat",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.kulitBerjerawatController,
          label: 'Kulit Berjerawat',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Kulit Berjerawat?',
              options: opsiYaTidak,
              controller: widget.kulitBerjerawatController,
              onSelected: (value) {
                selectedKulitBerjerawat = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),

        // Payudara Simetris
        Text(
          "Payudara Simetris",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.payudaraSimetrisController,
          label: 'Payudara Simetris',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Payudara Simetris?',
              options: opsiYaTidak,
              controller: widget.payudaraSimetrisController,
              onSelected: (value) {
                selectedPayudaraSimetris = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),

        // Benjolan Payudara
        Text(
          "Benjolan Payudara",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.benjolanPayudaraController,
          label: 'Benjolan Payudara',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Benjolan Payudara?',
              options: opsiYaTidak,
              controller: widget.benjolanPayudaraController,
              onSelected: (value) {
                selectedBenjolanPayudara = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),

        // Rambut Rontok
        Text(
          "Rambut Rontok",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: widget.rambutRontokController,
          label: 'Rambut Rontok',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Rambut Rontok?',
              options: opsiYaTidak,
              controller: widget.rambutRontokController,
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
