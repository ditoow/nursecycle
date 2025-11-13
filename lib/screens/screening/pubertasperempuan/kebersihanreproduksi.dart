import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertasperempuan.dart';

class KebersihanReproduksiFields extends StatefulWidget {
  const KebersihanReproduksiFields({super.key});

  @override
  State<KebersihanReproduksiFields> createState() =>
      _KebersihanReproduksiFieldsState();
}

class _KebersihanReproduksiFieldsState
    extends State<KebersihanReproduksiFields> {
  String? selectedEdukasiKebersihan;
  String? selectedKebiasaanGanti;

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
            "Kebersihan dan Reproduksi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Edukasi kebersihan haid diterima",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.edukasiKebersihanHaidController,
          label: 'Edukasi kebersihan haid',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Edukasi kebersihan haid diterima?',
              options: opsiYaTidak,
              controller: PubertasControllers.edukasiKebersihanHaidController,
              onSelected: (value) {
                selectedEdukasiKebersihan = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Kebiasaan ganti pembalut benar",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.kebiasaanGantiPembalutController,
          label: 'Kebiasaan ganti pembalut',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Kebiasaan ganti pembalut benar?',
              options: opsiYaTidak,
              controller: PubertasControllers.kebiasaanGantiPembalutController,
              onSelected: (value) {
                selectedKebiasaanGanti = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
