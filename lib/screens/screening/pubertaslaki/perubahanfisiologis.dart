import 'package:flutter/material.dart';
import '../widgets/formscreening.dart';
import 'pubertaslaki.dart';

class PerubahanFisiologis extends StatefulWidget {
  const PerubahanFisiologis({super.key});

  @override
  State<PerubahanFisiologis> createState() => _PerubahanFisiologisState();
}

class _PerubahanFisiologisState extends State<PerubahanFisiologis> {
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
            "C. Perubahan Fisiologis",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 18),
        Text(
          "Nafsu makan meningkat",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.nafsuMakanController,
          label: 'Nafsu makan meningkat',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Nafsu makan meningkat?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.nafsuMakanController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Mimpi basah",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.mimpiBasahController,
          label: 'Mimpi basah',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Mimpi basah?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.mimpiBasahController,
              onSelected: (value) {},
            );
          },
          suffixIcon: Icons.arrow_drop_down,
        ),
        SizedBox(height: 20),
        Text(
          "Perubahan tidur",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Formscreening(
          controller: PubertasLakiControllers.perubahanTidurController,
          label: 'Perubahan tidur',
          hintText: 'Pilih Ya/Tidak',
          readOnly: true,
          onTap: () {
            _showSelectionDialog(
              title: 'Perubahan tidur?',
              options: ['Ya', 'Tidak'],
              controller: PubertasLakiControllers.perubahanTidurController,
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
