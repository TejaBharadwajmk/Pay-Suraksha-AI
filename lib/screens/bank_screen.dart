import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'create_pin_screen.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  String selectedBank = "";

  final banks = [
    "State Bank of India",
    "HDFC Bank",
    "ICICI Bank",
    "Axis Bank",
    "Canara Bank",
    "Union Bank",
    "Bank of Baroda",
    "Punjab National Bank",
  ];

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
                      "Select Your Bank",
                      style: AppTheme.headingLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Choose bank to link with GuardPay",
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    _bankList(),
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

  // ================= BANK LIST =================

  Widget _bankList() {
    return Expanded(
      child: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, i) {
          final bank = banks[i];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedBank = bank;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedBank == bank ? AppTheme.blue : AppTheme.border,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bank),
                  if (selectedBank == bank)
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.blue,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= BUTTON =================

  Widget _continueButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: selectedBank.isEmpty
            ? null
            : () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreatePinScreen(),
                  ),
                );
              },
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
