import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ImeiScannerScreen extends StatefulWidget {
  const ImeiScannerScreen({super.key});

  @override
  State<ImeiScannerScreen> createState() => _ImeiScannerScreenState();
}

class _ImeiScannerScreenState extends State<ImeiScannerScreen> {
  bool scanned = false;
  bool allowScan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(title: const Text("Scan IMEI"), centerTitle: true),

      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (!allowScan || scanned) return;

              final barcode = capture.barcodes.first;

              final String? code = barcode.rawValue;

              if (code != null && RegExp(r'^\d{15}$').hasMatch(code)) {
                scanned = true;

                Navigator.pop(context, code);
              }
            },
          ),

          Container(color: Colors.black.withOpacity(0.5)),

          // Center(
          //   child: Container(
          //     width: 280,
          //     height: 120,
          //
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.white, width: 3),
          //
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,

            child: Column(
              children: [
                const Text(
                  "Align IMEI Barcode Here",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Only 15-digit IMEI numbers are accepted",
                  style: TextStyle(color: Colors.white70),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      allowScan = true;
                    });
                  },
                  child: const Text("Scan IMEI"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
