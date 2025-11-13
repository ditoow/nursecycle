import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertaslaki.dart';

class SeksualSekunderLaki extends StatefulWidget {
  const SeksualSekunderLaki({super.key});

  @override
  State<SeksualSekunderLaki> createState() => _SeksualSekunderLakiState();
}

class _SeksualSekunderLakiState extends State<SeksualSekunderLaki> {
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
            "A. Tanda Seksual Sekunder (Tanner Stage)",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 18),
        Text(
          "Ukuran Testis",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.ukuranTestisController,
          label: 'Ukuran Testis (G1-G5)',
          hintText: 'Pilih Ukuran Testis',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Ukuran Testis',
              options: ['G1', 'G2', 'G3', 'G4', 'G5'],
              controller: PubertasLakiControllers.ukuranTestisController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Rambut Kemaluan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.rambutKemaluanController,
          label: 'Rambut Kemaluan (P1-P5)',
          hintText: 'Pilih Tahap Rambut Kemaluan',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Tahap Rambut Kemaluan',
              options: ['P1', 'P2', 'P3', 'P4', 'P5'],
              controller: PubertasLakiControllers.rambutKemaluanController,
              onSelected: (value) {},
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
          controller: PubertasLakiControllers.rambutKetiakController,
          label: 'Rambut Ketiak',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Rambut Ketiak',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.rambutKetiakController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Perubahan Suara",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.perubahanSuaraController,
          label: 'Perubahan Suara',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Perubahan Suara?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.perubahanSuaraController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Pertumbuhan Kumis/Jenggot",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.pertumbuhanKumisController,
          label: 'Pertumbuhan Kumis/Jenggot',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pertumbuhan Kumis/Jenggot?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.pertumbuhanKumisController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
