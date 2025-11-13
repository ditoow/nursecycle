import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertasperempuan.dart';

class PsikologisSosialFields extends StatefulWidget {
  const PsikologisSosialFields({super.key});

  @override
  State<PsikologisSosialFields> createState() => _PsikologisSosialFieldsState();
}

class _PsikologisSosialFieldsState extends State<PsikologisSosialFields> {
  String? selectedPerubahanEmosi;
  String? selectedCitraTubuh;
  String? selectedMenarikDiri;
  String? selectedRiwayatStres;
  String? selectedPolaTidur;

  final List<String> opsiYaTidak = ['Ya', 'Tidak'];
  final List<String> opsiRiwayatStres = ['Tidak', 'Pernah', 'Sedang'];

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
            "Psikologis dan Sosial",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Perubahan emosi sering",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.perubahanEmosiController,
          label: 'Perubahan emosi',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Perubahan emosi sering?',
              options: opsiYaTidak,
              controller: PubertasControllers.perubahanEmosiController,
              onSelected: (value) {
                selectedPerubahanEmosi = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Citra tubuh negatif",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.citraTubuhNegatifController,
          label: 'Citra tubuh negatif',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Citra tubuh negatif?',
              options: opsiYaTidak,
              controller: PubertasControllers.citraTubuhNegatifController,
              onSelected: (value) {
                selectedCitraTubuh = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Menarik diri dari teman",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.menarikDiriTemanController,
          label: 'Menarik diri dari teman',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Menarik diri dari teman?',
              options: opsiYaTidak,
              controller: PubertasControllers.menarikDiriTemanController,
              onSelected: (value) {
                selectedMenarikDiri = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Riwayat stres",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.riwayatStresController,
          label: 'Riwayat stres',
          hintText: 'Pilih riwayat stres',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Riwayat stres?',
              options: opsiRiwayatStres,
              controller: PubertasControllers.riwayatStresController,
              onSelected: (value) {
                selectedRiwayatStres = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Pola tidur terganggu",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.polaTidurTergangguController,
          label: 'Pola tidur terganggu',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pola tidur terganggu?',
              options: opsiYaTidak,
              controller: PubertasControllers.polaTidurTergangguController,
              onSelected: (value) {
                selectedPolaTidur = value;
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
