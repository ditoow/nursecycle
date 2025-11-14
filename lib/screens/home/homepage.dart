import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> data = [
    'Tidak ada keluhan',
    'Tekanan darah: Normal',
    'Suhu tubuh: 36.5°C',
    'Nadi: 80 bpm',
  ];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello Alexa",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Perempuan",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            // child: Padding(
            //   padding:
            //       EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 12),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "🩺 Riwayat Kesehatan",
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       Text(
            //         "Terakhir Update : 1 Nov 2024",
            //         style: TextStyle(
            //           fontSize: 12,
            //           fontWeight: FontWeight.w300,
            //         ),
            //       ),
            //       SizedBox(
            //         height: screenHeight * 1 / 8.2,
            //         child: ListView.builder(
            //           padding: const EdgeInsets.all(16),
            //           itemCount: data.length,
            //           itemBuilder: (context, index) {
            //             return Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 2),
            //               child: Text('• ${data[index]}'),
            //             );
            //           },
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ),
          Column(
            children: [],
          )
        ],
      ),
    );
  }
}
