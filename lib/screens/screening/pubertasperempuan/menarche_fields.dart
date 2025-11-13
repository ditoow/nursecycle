import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nursecycle/screens/screening/pubertasperempuan/kebersihanreproduksi.dart';
import 'package:nursecycle/screens/screening/pubertasperempuan/psikologsocial.dart';
import '../widgets/formscreening.dart';
import 'pemeriksaanfisik.dart';
import 'pubertasperempuan.dart';

class MenarcheFields extends StatefulWidget {
  const MenarcheFields({super.key});

  @override
  State<MenarcheFields> createState() => _MenarcheFieldsState();
}

class _MenarcheFieldsState extends State<MenarcheFields> {
  String? selectedSiklusHaid;
  String? selectedVolumeHaid;
  String? selectedNyeriHaid;
  String? selectedKeputihan;

  final List<String> opsiSiklusHaid = ['Teratur', 'Tidak Teratur'];
  final List<String> opsiVolumeHaid = ['Sedikit', 'Normal', 'Banyak'];
  final List<String> opsiNyeriHaid = ['Tidak Ada', 'Ringan', 'Sedang', 'Berat'];
  final List<String> opsiKeputihan = ['Tidak Ada', 'Normal', 'Abnormal'];

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
        Text(
          "Usia Menarche",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.usiaMenarcheController,
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
        Text(
          "Siklus Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.siklusHaidController,
          label: 'Siklus Haid',
          hintText: 'Pilih siklus haid',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Siklus Haid',
              options: opsiSiklusHaid,
              controller: PubertasControllers.siklusHaidController,
              onSelected: (value) {
                selectedSiklusHaid = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Lama Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.lamaHaidController,
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
        Text(
          "Volume Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.volumeHaidController,
          label: 'Volume Haid',
          hintText: 'Pilih volume haid',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Volume Haid',
              options: opsiVolumeHaid,
              controller: PubertasControllers.volumeHaidController,
              onSelected: (value) {
                selectedVolumeHaid = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Nyeri Haid",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.nyeriHaidController,
          label: 'Nyeri Haid',
          hintText: 'Pilih tingkat nyeri haid',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Tingkat Nyeri Haid',
              options: opsiNyeriHaid,
              controller: PubertasControllers.nyeriHaidController,
              onSelected: (value) {
                selectedNyeriHaid = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Keputihan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasControllers.keputihanController,
          label: 'Keputihan',
          hintText: 'Pilih tingkat Keputihan',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Pilih Tingkat Keputihan',
              options: opsiKeputihan,
              controller: PubertasControllers.keputihanController,
              onSelected: (value) {
                selectedKeputihan = value;
              },
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 24),
        PemeriksaanFisik(),
        PsikologisSosialFields(),
        SizedBox(height: 12),
        KebersihanReproduksiFields(),
      ],
    );
  }
}
