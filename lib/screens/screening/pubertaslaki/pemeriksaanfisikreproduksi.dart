import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertaslaki.dart';

class PemeriksaanFisikReproduksi extends StatefulWidget {
  const PemeriksaanFisikReproduksi({super.key});

  @override
  State<PemeriksaanFisikReproduksi> createState() =>
      _PemeriksaanFisikReproduksiState();
}

class _PemeriksaanFisikReproduksiState
    extends State<PemeriksaanFisikReproduksi> {
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
            "B. Pemeriksaan Fisik Reproduksi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 18),
        Text(
          "Testis Simetris",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.testisSimetrisController,
          label: 'Testis Simetris',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Testis Simetris?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.testisSimetrisController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Testis Turun Keduanya",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.testisTurunController,
          label: 'Testis Turun Keduanya',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Testis Turun Keduanya?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.testisTurunController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Ginekomastia",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.ginekomastiaController,
          label: 'Ginekomastia',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Ginekomastia?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.ginekomastiaController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Jerawat",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.jerawatController,
          label: 'Jerawat',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Jerawat?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.jerawatController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Pertumbuhan cepat",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.pertumbuhanCepatController,
          label: 'Pertumbuhan cepat',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pertumbuhan cepat?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.pertumbuhanCepatController,
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
