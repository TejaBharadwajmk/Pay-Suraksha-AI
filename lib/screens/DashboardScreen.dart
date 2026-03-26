import 'package:flutter/material.dart';
import 'dart:math' as math;

// â”€â”€â”€ DashboardScreen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _enterCtrl;

  late Animation<double> _fade;
  late Animation<double> _slide;
  late Animation<double> _pulse;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _orbCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _pulseCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 20, end: 0).animate(
        CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(begin: 0.92, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _pulseCtrl.dispose();
    _enterCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13)),
      backgroundColor: const Color(0xFF1A2540),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C14),
      body: Stack(
        children: [
          // â”€â”€ Orb background â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) => CustomPaint(
              painter: _OrbPainter(_orbCtrl.value),
              size: Size.infinite,
            ),
          ),

          // â”€â”€ Main content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          SafeArea(
            child: AnimatedBuilder(
              animation: _enterCtrl,
              builder: (context, child) => Opacity(
                opacity: _fade.value,
                child: Transform.translate(
                    offset: Offset(0, _slide.value), child: child),
              ),
              child: Column(
                children: [
                  // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  _buildHeader(),

                  // â”€â”€ Scrollable body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildFraudBanner(),
                          _buildScanButton(),
                          _buildQuickActions(),
                          _buildUpiCard(),
                          _buildSectionTitle("SERVICES", "See all"),
                          _buildServicesGrid(),
                          _buildSectionTitle("RECENT", "View all"),
                          _buildTransactions(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // â”€â”€ Bottom nav â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3568F5), Color(0xFF1235B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF3568F5).withValues(alpha: 0.4),
                    blurRadius: 16)
              ],
            ),
            child: const Center(
              child: Text("RK",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
            ),
          ),

          const SizedBox(width: 12),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Good morning â˜€ï¸",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.38),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                const Text("Teja-Abhi",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4)),
              ],
            ),
          ),

          // Bell
          _HeaderBtn(
            icon: Icons.notifications_outlined,
            onTap: () => _showSnack("Notifications"),
          ),
          const SizedBox(width: 8),
          // Search
          _HeaderBtn(
            icon: Icons.search_rounded,
            onTap: () => _showSnack("Search"),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Fraud Alert Banner â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildFraudBanner() {
    return GestureDetector(
      onTap: () => _showSnack("â†’ Navigate to FraudMapScreen"),
      child: AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (_, __) => Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFEF4444).withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Pulsing dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEF4444),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444)
                          .withValues(alpha: _pulse.value * 0.8),
                      blurRadius: 8 * _pulse.value,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "âš ï¸  3 fraud alerts in your area",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEF4444)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "KYC scam reported near you Â· Tap to view",
                      style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right_rounded,
                  color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                  size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€ Big Scan Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildScanButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _showSnack("â†’ Navigate to QR Scanner"),
        child: AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (_, __) => SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Transform.scale(
                  scale: _pulse.value,
                  child: Container(
                    width: 195,
                    height: 195,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3568F5).withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                // Middle ring
                Transform.scale(
                  scale: 0.95 + (_pulse.value - 0.92) * 0.5,
                  child: Container(
                    width: 168,
                    height: 168,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3568F5).withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                // Main button
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4C8AFF),
                        Color(0xFF2048D4),
                        Color(0xFF1235B0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3568F5).withValues(alpha: 0.45),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFF3568F5).withValues(alpha: 0.15),
                        blurRadius: 80,
                        spreadRadius: 8,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner_rounded,
                          color: Colors.white, size: 46),
                      const SizedBox(height: 6),
                      Text(
                        "SCAN & PAY",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // â”€â”€ Quick Actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildQuickActions() {
    final actions = [
      (Icons.person_outline_rounded, "Contact"),
      (Icons.account_balance_outlined, "Bank"),
      (Icons.qr_code_rounded, "UPI"),
      (Icons.sign_language_rounded, "SignPay"),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((a) {
          return GestureDetector(
            onTap: () => _showSnack("â†’ ${a.$2}"),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Icon(a.$1, color: const Color(0xFF4C8AFF), size: 24),
                ),
                const SizedBox(height: 7),
                Text(a.$2,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // â”€â”€ UPI Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildUpiCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3568F5).withValues(alpha: 0.18),
            const Color(0xFF1235B0).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFF3568F5).withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Linked UPI ID",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.4))),
                const SizedBox(height: 5),
                const Text("rahul@upi",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5)),
                const SizedBox(height: 4),
                Text("SBI Bank Â· â€¢â€¢â€¢â€¢4521",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.35))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Text("UPI",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.7))),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showSnack("Show QR Code"),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Icon(Icons.qr_code_2_rounded,
                      size: 20, color: Colors.white.withValues(alpha: 0.6)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ Section Title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildSectionTitle(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.4),
                  letterSpacing: 1.0)),
          const Spacer(),
          GestureDetector(
            onTap: () => _showSnack(action),
            child: Text(action,
                style: const TextStyle(fontSize: 11, color: Color(0xFF4C8AFF))),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Services Grid â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildServicesGrid() {
    final services = [
      (
        Icons.phone_android_rounded,
        "Recharge",
        const Color(0xFF4C8AFF),
        const Color(0xFF1A2A50)
      ),
      (
        Icons.receipt_long_rounded,
        "Bills",
        const Color(0xFF34D399),
        const Color(0xFF0E2A20)
      ),
      (
        Icons.shield_outlined,
        "Insurance",
        const Color(0xFF3568F5),
        const Color(0xFF1A2450)
      ),
      (
        Icons.account_balance_rounded,
        "Loans",
        const Color(0xFFFBBF24),
        const Color(0xFF2A1F0A)
      ),
      (
        Icons.flight_rounded,
        "Travel",
        const Color(0xFFA78BFA),
        const Color(0xFF1E1A40)
      ),
      (
        Icons.more_horiz_rounded,
        "More",
        Colors.white54,
        const Color(0xFF1A1F2E)
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
        children: services.map((s) {
          return GestureDetector(
            onTap: () => _showSnack("â†’ ${s.$2}"),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: s.$4,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(s.$1, color: s.$3, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(s.$2,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // â”€â”€ Recent Transactions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildTransactions() {
    final txns = [
      (
        "AM",
        "Amit Kumar",
        "Today Â· 10:24 AM",
        "âˆ’â‚¹500",
        false,
        true,
        [const Color(0xFF34D399), const Color(0xFF059669)]
      ),
      (
        "SW",
        "Swiggy",
        "Yesterday Â· 8:10 PM",
        "âˆ’â‚¹349",
        false,
        true,
        [const Color(0xFF4C8AFF), const Color(0xFF2048D4)]
      ),
      (
        "MR",
        "Mahesh Raj",
        "Yesterday Â· 2:05 PM",
        "+â‚¹1,200",
        true,
        false,
        [const Color(0xFFFBBF24), const Color(0xFFD97706)]
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: txns.map((t) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: t.$7),
                  ),
                  child: Center(
                    child: Text(t.$1,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13)),
                  ),
                ),

                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.$2,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(t.$3,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.35))),
                      if (t.$6) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF34D399).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "âœ“  GuardPay Safe",
                            style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF34D399),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.$4,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: t.$5
                            ? const Color(0xFF34D399)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.$5 ? "Received" : "Sent",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.3)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // â”€â”€ Bottom Nav â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF080C14).withValues(alpha: 0.95),
        border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
      ),
      child: Row(
        children: [
          _NavItem(
              icon: Icons.home_rounded,
              label: "Home",
              selected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0)),
          _NavItem(
              icon: Icons.grid_view_rounded,
              label: "Apps",
              selected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1)),

          // Center scan button
          Expanded(
            child: GestureDetector(
              onTap: () => _showSnack("â†’ Navigate to QR Scanner"),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4C8AFF), Color(0xFF2048D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color:
                                const Color(0xFF3568F5).withValues(alpha: 0.55),
                            blurRadius: 20)
                      ],
                      border:
                          Border.all(color: const Color(0xFF080C14), width: 3),
                    ),
                    child: const Icon(Icons.qr_code_scanner_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Text("Scan",
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          _NavItem(
              icon: Icons.shield_rounded,
              label: "Guard",
              selected: _selectedTab == 3,
              onTap: () => setState(() => _selectedTab = 3)),
          _NavItem(
              icon: Icons.person_rounded,
              label: "Profile",
              selected: _selectedTab == 4,
              onTap: () => setState(() => _selectedTab = 4)),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Header button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 18),
      ),
    );
  }
}

// â”€â”€â”€ Nav item â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 22,
                color: selected
                    ? const Color(0xFF4C8AFF)
                    : Colors.white.withValues(alpha: 0.3)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? const Color(0xFF4C8AFF)
                      : Colors.white.withValues(alpha: 0.3),
                )),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Orb painter â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _OrbPainter extends CustomPainter {
  final double t;
  _OrbPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      (
        Offset(size.width * 0.1 + math.sin(t * math.pi * 2) * 25,
            size.height * 0.2 + math.cos(t * math.pi * 2) * 20),
        size.width * 0.6,
        const Color(0xFF112060)
      ),
      (
        Offset(size.width * 0.85 + math.cos(t * math.pi * 2) * 20,
            size.height * 0.45 + math.sin(t * math.pi * 2) * 25),
        size.width * 0.5,
        const Color(0xFF0A1840)
      ),
      (
        Offset(size.width * 0.2 + math.sin(t * math.pi * 2) * 15,
            size.height * 0.75 + math.cos(t * math.pi * 2) * 15),
        size.width * 0.45,
        const Color(0xFF0D1F50)
      ),
    ];
    for (final o in orbs) {
      canvas.drawCircle(
          o.$1,
          o.$2,
          Paint()
            ..shader = RadialGradient(
                    colors: [o.$3.withValues(alpha: 0.7), Colors.transparent])
                .createShader(Rect.fromCircle(center: o.$1, radius: o.$2)));
    }
    final dot = Paint()
      ..color = Colors.white.withValues(alpha: 0.018)
      ..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 36) {
      for (double y = 0; y < size.height; y += 36) {
        canvas.drawCircle(Offset(x, y), 1.1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_OrbPainter o) => o.t != t;
}
