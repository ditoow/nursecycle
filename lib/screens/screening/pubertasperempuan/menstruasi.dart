import 'package:flutter/material.dart';
import 'package:nursecycle/screens/screening/widgets/formscreening.dart';
import 'menarche_fields.dart';
import 'pubertasperempuan.dart';

class Menstruasi extends StatefulWidget {
  const Menstruasi({super.key});

  @override
  State<Menstruasi> createState() => _MenstruasiState();
}

class _MenstruasiState extends State<Menstruasi> {
  String? selectedMenarche;
  String? selectedSiklusHaid;
  String? selectedVolumeHaid;
  String? selectedNyeriHaid;
  String? selectedKeputihan;

  final List<String> opsiMenarche = ['Ya', 'Tidak'];

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
            "Menstruasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Sudah Menarche",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.menarcheController,
          label: 'Sudah Menarche',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Sudah Menarche?',
              options: opsiMenarche,
              controller: PubertasControllers.menarcheController,
              onSelected: (value) {
                selectedMenarche = value;

                if (value == 'Tidak') {
                  PubertasControllers.usiaMenarcheController.clear();
                  PubertasControllers.siklusHaidController.clear();
                  PubertasControllers.lamaHaidController.clear();
                  PubertasControllers.volumeHaidController.clear();
                  PubertasControllers.nyeriHaidController.clear();
                  PubertasControllers.keputihanController.clear();
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
        MenarcheFields(),
      ],
    );
  }
}
