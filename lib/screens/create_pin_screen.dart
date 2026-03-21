import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'face_screen.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  String pin = "";

  void press(String n) {
    if (pin.length == 6) return;

    setState(() {
      pin += n;
    });

    if (pin.length == 6) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const FaceScreen(),
            ),
          );
        },
      );
    }
  }

  void del() {
    if (pin.isEmpty) return;

    setState(() {
      pin = pin.substring(0, pin.length - 1);
    });
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
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Create PIN",
                      style: AppTheme.headingLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter 6 digit passcode",
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    _dots(),
                    const SizedBox(height: 20),
                    _pad(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text(
            "GuardPay AI",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // DOTS

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (i) => Container(
          margin: const EdgeInsets.all(8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < pin.length ? AppTheme.blue : Colors.transparent,
            border: Border.all(
              color: AppTheme.blue,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  // KEYPAD

  Widget _pad() {
    return Expanded(
      child: GridView.builder(
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (c, i) {
          if (i == 9) return const SizedBox();

          if (i == 11) {
            return IconButton(
              onPressed: del,
              icon: const Icon(Icons.backspace),
            );
          }

          final n = i == 10 ? "0" : "${i + 1}";

          return TextButton(
            onPressed: () => press(n),
            child: Text(
              n,
              style: const TextStyle(fontSize: 24),
            ),
          );
        },
      ),
    );
  }
}
