import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/shared_widgets.dart'; // ✅ FIXED PATH
import '../theme/app_theme.dart';
import 'scan_screen.dart';
import 'contact_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        bottom: false, // ✅ FIX OVERFLOW
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header()),
              SliverToBoxAdapter(child: _scanButton()),
              SliverToBoxAdapter(child: _quickActions()),
              SliverToBoxAdapter(child: _upiCard()),
              SliverToBoxAdapter(child: _services()),
              SliverToBoxAdapter(child: _transactions()),

              /// ❌ REMOVED EXTRA SPACE (IMPORTANT)
              // const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
        },
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        gradient: AppTheme.headerGradient,
      ),
      child: Row(
        children: [
          const AvatarCircle(initials: "RK", size: 44),
          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good morning",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7), // ✅ FIXED
                ),
              ),
              Text(
                "Teja-Abhi",
                style: GoogleFonts.sora(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Spacer(),
          _icon(Icons.notifications),
          const SizedBox(width: 8),
          _icon(Icons.search),
        ],
      ),
    );
  }

  Widget _icon(IconData i) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2), // ✅ FIXED
      ),
      child: Icon(i, color: Colors.white),
    );
  }

  // ================= SCAN BUTTON =================

  Widget _scanButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanScreen()),
            );
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.blue.withOpacity(0.4), // ✅ FIXED
                  blurRadius: 25,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 55,
            ),
          ),
        ),
      ),
    );
  }

  // ================= QUICK ACTIONS =================

  Widget _quickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _gridBtn(Icons.person, "Contact"),
          _gridBtn(Icons.account_balance, "Bank"),
          _gridBtn(Icons.qr_code, "UPI"),
          _gridBtn(Icons.draw, "Sign Pay"),
        ],
      ),
    );
  }

  Widget _gridBtn(IconData i, String t) {
    return GestureDetector(
      onTap: () {
        if (t == "Contact") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ContactScreen(),
            ),
          );
        }
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // ✅ FIXED
                  blurRadius: 6,
                )
              ],
            ),
            child: Center(
              child: Icon(
                i,
                color: AppTheme.blue,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= UPI CARD =================

  Widget _upiCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UPI ID",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "rahul@upi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.blue.withOpacity(0.1), // ✅ FIXED
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.qr_code),
            )
          ],
        ),
      ),
    );
  }

  // ================= SERVICES =================

  Widget _services() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        children: [
          _serviceItem(Icons.phone_android, "Recharge"),
          _serviceItem(Icons.money, "Bills"),
          _serviceItem(Icons.shield, "Insurance"),
          _serviceItem(Icons.account_balance, "Loans"),
          _serviceItem(Icons.flight, "Travel"),
          _serviceItem(Icons.more_horiz, "More"),
        ],
      ),
    );
  }

  Widget _serviceItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // ✅ FIXED
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.blue, size: 40),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TRANSACTIONS =================

  Widget _transactions() {
    return const AppCard(
      padding: EdgeInsets.all(16),
      child: Text("Transactions"),
    );
  }
}