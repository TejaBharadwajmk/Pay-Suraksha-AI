import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

/// 🔥 TEMP AmountScreen (inside same file to avoid errors)
class AmountScreen extends StatelessWidget {
  final String name;
  final String upiId;
  final String amount;

  const AmountScreen({
    super.key,
    required this.name,
    required this.upiId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Center(
        child: Text(
          "Paying to: $name\nUPI: $upiId\nAmount: $amount",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// 🔥 MAIN SCAN SCREEN
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController();

  bool _isScanned = false;
  bool _flashOn = false;

  /// 🔐 HANDLE QR RESULT
  void _handleScan(String raw) {
    final uri = Uri.tryParse(raw);

    String name = "Unknown";
    String upiId = raw;
    String amount = "";

    if (uri != null && uri.scheme == "upi") {
      name = uri.queryParameters['pn'] ?? "Unknown";
      upiId = uri.queryParameters['pa'] ?? raw;
      amount = uri.queryParameters['am'] ?? "";
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AmountScreen(
          name: name,
          upiId: upiId,
          amount: amount,
        ),
      ),
    );
  }

  /// 🔦 FLASH TOGGLE
  void _toggleFlash() {
    controller.toggleTorch();

    setState(() {
      _flashOn = !_flashOn;
    });

    HapticFeedback.lightImpact();
  }

  /// 🖼️ PICK IMAGE
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image selected")),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 📷 CAMERA SCANNER
          MobileScanner(
            controller: controller,
            onDetect: (barcodeCapture) {
              if (_isScanned) return;

              final barcodes = barcodeCapture.barcodes;

              if (barcodes.isNotEmpty) {
                final raw = barcodes.first.rawValue;

                if (raw != null) {
                  _isScanned = true;
                  _handleScan(raw);
                }
              }
            },
          ),

          /// 🔲 SCAN BOX
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          /// 🔙 BACK BUTTON
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// 🔦 FLASH BUTTON
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: _toggleFlash,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _flashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          /// 📍 TEXT
          const Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Scan QR code to pay",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),

          /// 🖼️ UPLOAD BUTTON
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Upload QR"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}