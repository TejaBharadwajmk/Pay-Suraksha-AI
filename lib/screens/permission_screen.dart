import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'face_screen.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool camera = false;
  bool location = false;
  bool storage = false;
  bool terms = false;

  bool get allAllowed => camera && location && storage && terms;

  Future<void> sendPermission() async {
    final url = Uri.parse(
      "https://4ew7tczw5f.execute-api.eu-north-1.amazonaws.com/dev/permission",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "phone": "9999999999",
        "permission": true,
      }),
    );

    // ignore: avoid_print
    print("PERMISSION RESPONSE = ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Permissions Required",
                      style: AppTheme.headingLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "GuardPay needs these permissions to keep your payments secure",
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    _tile(
                      "Camera",
                      "For Face Login & QR Scan",
                      camera,
                      (v) async {
                        if (v) {
                          var status = await Permission.camera.request();
                          if (status.isGranted) {
                            setState(() => camera = true);
                          }
                        } else {
                          setState(() => camera = false);
                        }
                      },
                    ),
                    _tile(
                      "Location",
                      "Fraud detection & security",
                      location,
                      (v) async {
                        if (v) {
                          var status = await Permission.location.request();
                          if (status.isGranted) {
                            setState(() => location = true);
                          }
                        } else {
                          setState(() => location = false);
                        }
                      },
                    ),
                    _tile(
                      "Storage",
                      "Save receipts & documents",
                      storage,
                      (v) async {
                        if (v) {
                          var status = await Permission.photos.request();
                          if (status.isGranted) {
                            setState(() => storage = true);
                          }
                        } else {
                          setState(() => storage = false);
                        }
                      },
                    ),
                    _tile(
                      "Accept Terms",
                      "Agree to RBI & security policy",
                      terms,
                      (v) => setState(() => terms = v),
                    ),
                    const Spacer(),
                    _continueButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "GuardPay AI",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TILE =================

  Widget _tile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.headingSmall),
                Text(subtitle, style: AppTheme.bodyMedium),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.blue,
          ),
        ],
      ),
    );
  }

  // ================= BUTTON =================

  Widget _continueButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: allAllowed
            ? () async {
                await sendPermission();

                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FaceScreen(),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          "Continue",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
