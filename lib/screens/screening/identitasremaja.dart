// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:nursecycle/core/inputformat.dart';
import 'package:nursecycle/screens/screening/antropometri.dart';
import 'package:nursecycle/screens/screening/widgets/formscreening.dart';

final TextEditingController namalengkapcontroller = TextEditingController();
final TextEditingController tanggallahircontroller = TextEditingController();
final TextEditingController usiacontroller = TextEditingController();
final TextEditingController sekolahkelascontroller = TextEditingController();
final TextEditingController alamatcontroller = TextEditingController();
final TextEditingController ortuwalicontroller = TextEditingController();
final TextEditingController kontakcontroller = TextEditingController();

class Identitasremaja extends StatefulWidget {
  const Identitasremaja({super.key});

  @override
  State<Identitasremaja> createState() => _IdentitasremajaState();
}

class _IdentitasremajaState extends State<Identitasremaja> {
  String selectedRole = 'laki';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Data Identitas Remaja",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Lengkap",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: namalengkapcontroller,
                label: 'Nama Lengkap',
                hintText: "Masukkan Nama Lengkap",
              ),
              SizedBox(height: 12),
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Laki - Laki',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: 'laki',
                      groupValue: selectedRole,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Perempuan',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: 'perempuan',
                      groupValue: selectedRole,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                "Tanggal Lahir",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: tanggallahircontroller,
                label: 'Tanggal Lahir',
                readOnly: true,
                suffixIcon: Icons.calendar_today,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now().subtract(Duration(days: 365 * 17)),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    final months = [
                      '',
                      'Januari',
                      'Februari',
                      'Maret',
                      'April',
                      'Mei',
                      'Juni',
                      'Juli',
                      'Agustus',
                      'September',
                      'Oktober',
                      'November',
                      'Desember'
                    ];
                    final formattedDate =
                        '${picked.day} ${months[picked.month]} ${picked.year}';
                    tanggallahircontroller.text = formattedDate;

                    final now = DateTime.now();
                    int age = now.year - picked.year;

                    if (now.month < picked.month ||
                        (now.month == picked.month && now.day < picked.day)) {
                      age--;
                    }

                    usiacontroller.text = '$age Tahun';
                  }
                },
              ),
              SizedBox(height: 12),
              Text(
                "Usia",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              IgnorePointer(
                child: Formscreening(
                  controller: usiacontroller,
                  label: 'Usia',
                  readOnly: true,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Sekolah / Kelas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: sekolahkelascontroller,
                label: 'Sekolah / Kelas',
                hintText: "Masukkan Sekolah / Kelas",
              ),
              SizedBox(height: 12),
              Text(
                "Alamat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: alamatcontroller,
                label: 'Alamat',
                hintText: "Masukkan Alamat",
              ),
              SizedBox(height: 12),
              Text(
                "Nama Orangtua / Wali",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: ortuwalicontroller,
                label: 'Nama Orangtua / Wali',
                hintText: "Masukkan Nama Orangtua / Wali",
              ),
              SizedBox(height: 12),
              Text(
                "Nomor Kontak",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Formscreening(
                controller: kontakcontroller,
                keyboardType: TextInputType.number,
                inputFormatters: AppInputFormatters.digitsOnly,
                label: 'Nomor Kontak',
                hintText: "Masukkan Nomor Kontak",
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(400, 48)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Antropometri(gender: selectedRole),
                      ),
                    );
                  },
                  child: Text(
                    "Next",
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
