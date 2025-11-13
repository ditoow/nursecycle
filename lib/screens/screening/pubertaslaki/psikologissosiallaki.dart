import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertaslaki.dart';

class PsikologisSosialLaki extends StatefulWidget {
  const PsikologisSosialLaki({super.key});

  @override
  State<PsikologisSosialLaki> createState() => _PsikologisSosialLakiState();
}

class _PsikologisSosialLakiState extends State<PsikologisSosialLaki> {
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
            "D. Psikologis dan Sosial",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 18),
        Text(
          "Emosi sulit dikontrol",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.emosiSulitController,
          label: 'Emosi sulit dikontrol',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Emosi sulit dikontrol?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.emosiSulitController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Perilaku agresif / menyendiri",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.perilakuAgresifController,
          label: 'Perilaku agresif / menyendiri',
          hintText: 'Pilih perilaku',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Perilaku agresif / menyendiri?',
              options: ['Agresif', 'Menyendiri', 'Keduanya', 'Tidak'],
              controller: PubertasLakiControllers.perilakuAgresifController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Masalah percaya diri",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.masalahPercayaDiriController,
          label: 'Masalah percaya diri',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Masalah percaya diri?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.masalahPercayaDiriController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Ketertarikan lawan jenis",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.ketertarikanLawanJenisController,
          label: 'Ketertarikan lawan jenis',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Ketertarikan lawan jenis?',
              options: ['Ya', 'Tidak'],
              controller:
                  PubertasLakiControllers.ketertarikanLawanJenisController,
              onSelected: (value) {},
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
          controller: PubertasLakiControllers.riwayatStresController,
          label: 'Riwayat stres',
          hintText: 'Pilih riwayat stres',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Riwayat stres?',
              options: ['Tidak', 'Pernah', 'Sedang'],
              controller: PubertasLakiControllers.riwayatStresController,
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
