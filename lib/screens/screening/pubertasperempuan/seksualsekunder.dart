import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertasperempuan.dart';

class SeksualSekunder extends StatefulWidget {
  const SeksualSekunder({super.key});

  @override
  State<SeksualSekunder> createState() => _SeksualSekunderState();
}

class _SeksualSekunderState extends State<SeksualSekunder> {
  String? selectedPayudara;
  String? selectedRambutKemaluan;
  String? selectedRambutKetiak;

  final List<String> tahapPayudara = ['M1', 'M2', 'M3', 'M4', 'M5'];
  final List<String> tahapRambutKemaluan = ['P1', 'P2', 'P3', 'P4', 'P5'];
  final List<String> opsiRambutKetiak = ['Ya', 'Tidak'];
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
            "Tanda Seksual Sekunder",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 4),
        SizedBox(height: 18),
        Text(
          "Tahap Pertumbuhan Payudara",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.payudaraController,
          label: 'Tahap Pertumbuhan Payudara (M1-M5)',
          hintText: 'Pilih Tahap Payudara',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Tahap Payudara',
              options: tahapPayudara,
              controller: PubertasControllers.payudaraController,
              onSelected: (value) {
                selectedPayudara = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Tahap Rambut Kemaluan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.rambutKemaluanController,
          label: 'Tahap Rambut Kemaluan (P1-P5)',
          hintText: 'Pilih Tahap Rambut Kemaluan',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Tahap Rambut Kemaluan',
              options: tahapRambutKemaluan,
              controller: PubertasControllers.rambutKemaluanController,
              onSelected: (value) {
                selectedRambutKemaluan = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Rambut Ketiak",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.rambutKetiakController,
          label: 'Rambut Ketiak',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Rambut Ketiak',
              options: opsiRambutKetiak,
              controller: PubertasControllers.rambutKetiakController,
              onSelected: (value) {
                selectedRambutKetiak = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
