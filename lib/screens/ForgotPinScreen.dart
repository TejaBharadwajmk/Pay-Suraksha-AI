import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'CreatePinScreen.dart';

// â”€â”€â”€ ForgotPinFaceScreen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Shown when user taps "Forgot PIN?" on LoginPinScreen
// Verifies face against stored data â†’ then navigates to CreatePinScreen

class ForgotPinFaceScreen extends StatefulWidget {
  const ForgotPinFaceScreen({super.key});

  @override
  State<ForgotPinFaceScreen> createState() => _ForgotPinFaceScreenState();
}

class _ForgotPinFaceScreenState extends State<ForgotPinFaceScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late AnimationController _enterCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;

  late Animation<double> _fade;
  late Animation<double> _slide;
  late Animation<double> _pulse;
  late Animation<double> _scan;

  bool _scanning = false;
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    _orbCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _scanCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 30, end: 0).animate(
        CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _scan = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut));

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _enterCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() => _scanning = true);
    await _scanCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 400));

    // TODO: SecurityService.verifyFaceForPinReset()

    setState(() {
      _scanning = false;
      _verified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C14),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, __) => CustomPaint(
                painter: _OrbPainter(_orbCtrl.value), size: Size.infinite),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _enterCtrl,
              builder: (context, child) => Opacity(
                opacity: _fade.value,
                child: Transform.translate(
                    offset: Offset(0, _slide.value), child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white70, size: 20),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Warning banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color:
                                const Color(0xFFFBBF24).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Color(0xFFFBBF24), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Your stored face data will be matched to verify your identity before resetting your PIN.",
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: const Color(0xFFFBBF24)
                                      .withValues(alpha: 0.85),
                                  height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Title
                    const Text(
                      "Verify your\nface identity",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1.0,
                          height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Face match required to create a new PIN",
                      style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.white.withValues(alpha: 0.4)),
                    ),

                    const SizedBox(height: 36),

                    // Camera circle â€” yellow tint for recovery flow
                    Center(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_pulseCtrl, _scanCtrl]),
                        builder: (_, __) => Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: _scanning ? 1.0 : _pulse.value,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _verified
                                        ? const Color(0xFF34D399)
                                            .withValues(alpha: 0.5)
                                        : const Color(0xFFFBBF24)
                                            .withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 195,
                              height: 195,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.04),
                                border: Border.all(
                                  color: _verified
                                      ? const Color(0xFF34D399)
                                          .withValues(alpha: 0.7)
                                      : const Color(0xFFFBBF24)
                                          .withValues(alpha: 0.6),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (_verified
                                            ? const Color(0xFF34D399)
                                            : const Color(0xFFFBBF24))
                                        .withValues(alpha: 0.2),
                                    blurRadius: 30,
                                    spreadRadius: 3,
                                  )
                                ],
                              ),
                              child: ClipOval(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(color: const Color(0xFF0D1525)),
                                    Icon(
                                      _verified
                                          ? Icons.check_circle_rounded
                                          : Icons.face_rounded,
                                      size: 70,
                                      color: (_verified
                                              ? const Color(0xFF34D399)
                                              : Colors.white)
                                          .withValues(alpha: 0.15),
                                    ),
                                    if (_scanning)
                                      Positioned(
                                        top: 195 * _scan.value - 2,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Colors.transparent,
                                              const Color(0xFFFBBF24)
                                                  .withValues(alpha: 0.8),
                                              Colors.transparent,
                                            ]),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Status
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _verified
                            ? Row(
                                key: const ValueKey('done'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF34D399), size: 18),
                                  const SizedBox(width: 8),
                                  Text("Face matched!",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFF34D399)
                                              .withValues(alpha: 0.9),
                                          fontWeight: FontWeight.w600)),
                                ],
                              )
                            : _scanning
                                ? Row(
                                    key: const ValueKey('scanning'),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      const Color(0xFFFBBF24)
                                                          .withValues(
                                                              alpha: 0.8)))),
                                      const SizedBox(width: 10),
                                      Text("Matching face...",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white
                                                  .withValues(alpha: 0.6))),
                                    ],
                                  )
                                : AnimatedBuilder(
                                    key: const ValueKey('blink'),
                                    animation: _pulseCtrl,
                                    builder: (_, __) => Opacity(
                                      opacity: _pulse.value,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                              Icons.remove_red_eye_rounded,
                                              color: Color(0xFFFBBF24),
                                              size: 20),
                                          const SizedBox(width: 8),
                                          Text("Blink your eye",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white
                                                      .withValues(alpha: 0.75),
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                      ),
                    ),

                    const Spacer(),

                    // CTA
                    _ActionButton(
                      label: _verified ? "Create New PIN" : "Verify Face",
                      loading: _scanning,
                      enabled: !_scanning,
                      isSuccess: _verified,
                      onTap: _verified
                          ? () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CreatePinScreen()))
                          : _startScan,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final bool loading;
  final bool enabled;
  final bool isSuccess;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label,
      required this.loading,
      required this.enabled,
      required this.onTap,
      this.isSuccess = false});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: widget.enabled
                ? LinearGradient(
                    colors: widget.isSuccess
                        ? [const Color(0xFF34D399), const Color(0xFF059669)]
                        : [const Color(0xFF4C8AFF), const Color(0xFF2048D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.enabled ? null : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: widget.enabled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: (widget.isSuccess
                              ? const Color(0xFF34D399)
                              : const Color(0xFF3568F5))
                          .withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)))
                : Text(widget.label,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.enabled
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.25),
                        letterSpacing: 0.3)),
          ),
        ),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double t;
  _OrbPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      (
        Offset(size.width * 0.1 + math.sin(t * math.pi * 2) * 25,
            size.height * 0.3 + math.cos(t * math.pi * 2) * 20),
        size.width * 0.6,
        const Color(0xFF112060)
      ),
      (
        Offset(size.width * 0.85 + math.cos(t * math.pi * 2) * 20,
            size.height * 0.55 + math.sin(t * math.pi * 2) * 25),
        size.width * 0.5,
        const Color(0xFF0A1840)
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
      ..color = Colors.white.withValues(alpha: 0.022)
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
