import 'package:flutter/material.dart';
import 'package:guardpay_ai/screens/LoginPinScreen.dart';
import 'dart:math' as math;
import 'PhoneAuthScreen.dart';
import 'LoginPinScreen.dart';
import 'LoginPhoneAuthScreen.dart';
// ─── Entry point (connect to your login/signup screens) ──────────────────────
// Replace these with your actual screen imports:
// import 'login_screen.dart';
// import 'signup_screen.dart';

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthSelectionScreen(),
    );
  }
}

// ─── AuthSelectionScreen ─────────────────────────────────────────────────────

class AuthSelectionScreen extends StatefulWidget {
  const AuthSelectionScreen({super.key});

  @override
  State<AuthSelectionScreen> createState() => _AuthSelectionScreenState();
}

class _AuthSelectionScreenState extends State<AuthSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _enterCtrl;
  late AnimationController _orbCtrl;

  late Animation<double> _fade;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C14),
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) => CustomPaint(
              painter: _OrbPainter(_orbCtrl.value),
              size: Size.infinite,
            ),
          ),

          SafeArea(
            child: AnimatedBuilder(
              animation: _enterCtrl,
              builder: (context, child) => Opacity(
                opacity: _fade.value,
                child: Transform.translate(
                  offset: Offset(0, _slide.value),
                  child: child,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Back button ──────────────────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ── Logo ─────────────────────────────────────────────────
                    Center(
                      child: AnimatedBuilder(
                        animation: _orbCtrl,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                            0,
                            math.sin(_orbCtrl.value * math.pi * 2) * 7,
                          ),
                          child: child,
                        ),
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF3568F5), Color(0xFF1235B0)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3568F5)
                                    .withValues(alpha: 0.45),
                                blurRadius: 32,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Inner ring
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.shield_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Brand name ────────────────────────────────────────────
                    const Center(
                      child: Text(
                        "Pay Suraksha AI",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: Text(
                        "Choose how you'd like to continue",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // ── Login button ──────────────────────────────────────────
                    _AuthButton(
                      label: "Login to existing account",
                      sublabel: "Welcome back",
                      icon: Icons.login_rounded,
                      isPrimary: true,
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (_) => const LoginScreen(),
                        // ));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPhoneAuthScreen(),
                            ));
                      },
                    ),

                    const SizedBox(height: 14),

                    // ── Signup button ─────────────────────────────────────────
                    _AuthButton(
                      label: "Create new account",
                      sublabel: "Join Pay Suraksha AI",
                      icon: Icons.person_add_rounded,
                      isPrimary: false,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PhoneAuthScreen(),
                            ));
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── Terms ─────────────────────────────────────────────────
                    Center(
                      child: Text(
                        "By continuing, you agree to our Terms & Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.white.withValues(alpha: 0.25),
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(color: Colors.white, fontSize: 13)),
        backgroundColor: const Color(0xFF1A2540),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─── Auth button ──────────────────────────────────────────────────────────────

class _AuthButton extends StatefulWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _AuthButton({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<_AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 72,
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4C8AFF), Color(0xFF2048D4)],
                  )
                : null,
            color: widget.isPrimary
                ? null
                : Colors.white.withValues(alpha: _pressed ? 0.1 : 0.06),
            borderRadius: BorderRadius.circular(20),
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF3568F5).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: widget.isPrimary
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isPrimary
                        ? Colors.white
                        : const Color(0xFF7AAEFF),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 14),

                // Text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.sublabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: widget.isPrimary
                              ? Colors.white.withValues(alpha: 0.65)
                              : Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: widget.isPrimary
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.85),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: widget.isPrimary
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.3),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Background orb painter ───────────────────────────────────────────────────

class _OrbPainter extends CustomPainter {
  final double t;
  _OrbPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      (
        Offset(
          size.width * 0.1 + math.sin(t * math.pi * 2) * 25,
          size.height * 0.3 + math.cos(t * math.pi * 2) * 20,
        ),
        size.width * 0.6,
        const Color(0xFF112060),
      ),
      (
        Offset(
          size.width * 0.85 + math.cos(t * math.pi * 2) * 20,
          size.height * 0.55 + math.sin(t * math.pi * 2) * 25,
        ),
        size.width * 0.5,
        const Color(0xFF0A1840),
      ),
    ];

    for (final o in orbs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [o.$3.withValues(alpha: 0.7), Colors.transparent],
        ).createShader(Rect.fromCircle(center: o.$1, radius: o.$2));
      canvas.drawCircle(o.$1, o.$2, paint);
    }

    // Dot grid
    final dot = Paint()
      ..color = Colors.white.withValues(alpha: 0.022)
      ..style = PaintingStyle.fill;
    const s = 36.0;
    for (double x = 0; x < size.width; x += s) {
      for (double y = 0; y < size.height; y += s) {
        canvas.drawCircle(Offset(x, y), 1.1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_OrbPainter o) => o.t != t;
}
