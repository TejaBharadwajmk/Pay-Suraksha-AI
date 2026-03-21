import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool agree = false;

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
                      "Terms & Conditions",
                      style: AppTheme.headingLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please read and accept the terms to continue using GuardPay AI.",
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    _termsBox(),
                    const SizedBox(height: 10),
                    _agree(),
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

  // ================= TERMS BOX =================

  Widget _termsBox() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: const SingleChildScrollView(
          child: Text(
            "GuardPay AI Terms & Conditions\n\n"
            "1. Your data is encrypted.\n"
            "2. RBI compliant.\n"
            "3. Face login secure.\n"
            "4. No fraud protection enabled.\n"
            "5. Bank-level security.\n\n"
            "By continuing you agree to our policy.",
          ),
        ),
      ),
    );
  }

  // ================= CHECKBOX =================

  Widget _agree() {
    return Row(
      children: [
        Checkbox(
          value: agree,
          onChanged: (v) {
            setState(() {
              agree = v!;
            });
          },
        ),
        const Text("I agree to Terms & Conditions"),
      ],
    );
  }

  // ================= BUTTON =================

  Widget _continueButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: agree
            ? () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
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
