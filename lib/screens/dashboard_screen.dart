import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

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
        child: _buildDashboard(),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
        },
      ),
    );
  }

  // ================= DASHBOARD =================

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildScanCard(),
              const SizedBox(height: 14),
              _buildPromo(),
              const SizedBox(height: 14),
              _buildServices(),
              const SizedBox(height: 14),
              _buildRecentTxns(),
              const SizedBox(height: 14),
              _buildAiShield(),
            ]),
          ),
        ),
      ],
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.headerGradient,
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 68),
      child: Column(
        children: [
          Row(
            children: [
              const AvatarCircle(
                initials: 'RK',
                size: 44,
                gradient: LinearGradient(
                  colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Rahul Kumar',
                    style: GoogleFonts.sora(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _iconBtn(Icons.notifications),
              const SizedBox(width: 10),
              _iconBtn(Icons.search),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TOTAL BALANCE",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹ 2,48,350",
                  style: GoogleFonts.sora(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  // ================= SCAN CARD =================

  Widget _buildScanCard() {
    return Transform.translate(
      offset: const Offset(0, -44),
      child: AppCard(
        child: Column(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Scan & Pay"),
          ],
        ),
      ),
    );
  }

  // ================= PROMO =================

  Widget _buildPromo() {
    return AppCard(
      child: const Text(
        "Promo Card",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  // ================= SERVICES =================

  Widget _buildServices() {
    return AppCard(
      child: const Text(
        "Services",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  // ================= TXNS =================

  Widget _buildRecentTxns() {
    return AppCard(
      child: const Text(
        "Recent Transactions",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  // ================= AI SHIELD =================

  Widget _buildAiShield() {
    return AppCard(
      child: const Text(
        "AI Shield Active",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
