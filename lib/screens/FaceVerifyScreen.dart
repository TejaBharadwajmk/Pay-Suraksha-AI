import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'PermissionsScreen.dart';

// â”€â”€â”€ FaceVerifyScreen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class FaceVerifyScreen extends StatefulWidget {
  const FaceVerifyScreen({super.key});

  @override
  State<FaceVerifyScreen> createState() => _FaceVerifyScreenState();
}

class _FaceVerifyScreenState extends State<FaceVerifyScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late AnimationController _enterCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late Animation<double> _fade;
  late Animation<double> _slide;
  late Animation<double> _pulse;
  late Animation<double> _scan;

  bool _verified = false;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();

    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );
    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _scan = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut),
    );

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

  Future<void> _startVerification() async {
    setState(() => _scanning = true);
    await _scanCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _scanning = false;
      _verified = true;
    });
    _showSnack("âœ“ Face Verified Successfully");
  }

  void _showSnack(String msg) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C14),
      body: Stack(
        children: [
          // Background orbs
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

                    // â”€â”€ Back button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

                    const SizedBox(height: 36),

                    // â”€â”€ Title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    const Text(
                      "Face Verification",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Position your face inside the circle",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),

                    const SizedBox(height: 44),

                    // â”€â”€ Camera circle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Center(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_pulseCtrl, _scanCtrl]),
                        builder: (_, __) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer pulse ring
                              Transform.scale(
                                scale: _scanning ? 1.0 : _pulse.value,
                                child: Container(
                                  width: 260,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _verified
                                          ? const Color(0xFF34D399)
                                              .withValues(alpha: 0.5)
                                          : const Color(0xFF3568F5)
                                              .withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),

                              // Middle ring
                              Container(
                                width: 240,
                                height: 240,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _verified
                                        ? const Color(0xFF34D399)
                                            .withValues(alpha: 0.7)
                                        : const Color(0xFF3568F5)
                                            .withValues(alpha: 0.6),
                                    width: 2,
                                  ),
                                ),
                              ),

                              // Camera preview area
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.04),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_verified
                                              ? const Color(0xFF34D399)
                                              : const Color(0xFF3568F5))
                                          .withValues(alpha: 0.25),
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Simulated camera background
                                      Container(
                                        color: const Color(0xFF0D1525),
                                      ),

                                      // Face outline placeholder
                                      Icon(
                                        _verified
                                            ? Icons.check_circle_rounded
                                            : Icons.face_rounded,
                                        size: 90,
                                        color: (_verified
                                                ? const Color(0xFF34D399)
                                                : Colors.white)
                                            .withValues(alpha: 0.15),
                                      ),

                                      // Scan line animation
                                      if (_scanning)
                                        Positioned(
                                          top: 220 * _scan.value - 2,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 2,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  const Color(0xFF4C8AFF)
                                                      .withValues(alpha: 0.8),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                      // Corner brackets
                                      ..._buildCornerBrackets(_verified),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 36),

                    // â”€â”€ Blink instruction â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _verified
                            ? Row(
                                key: const ValueKey('done'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF34D399), size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Verification complete",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: const Color(0xFF34D399)
                                          .withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
                                            const Color(0xFF4C8AFF)
                                                .withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Scanning face...",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white
                                              .withValues(alpha: 0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    key: const ValueKey('blink'),
                                    children: [
                                      // Blink eye animated icon
                                      AnimatedBuilder(
                                        animation: _pulseCtrl,
                                        builder: (_, __) => Opacity(
                                          opacity: _pulse.value,
                                          child: const Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: Color(0xFF4C8AFF),
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Blink your eye",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white
                                              .withValues(alpha: 0.75),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "to confirm you're a real person",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),

                    const Spacer(),

                    // â”€â”€ Verify Face button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    _PrimaryButton(
                      label: _verified ? "Continue" : "Verify Face",
                      loading: _scanning,
                      isSuccess: _verified,
                      onTap: _verified
                          ? () {
                              _showSnack("Face Verified");

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PermissionsScreen(),
                                ),
                              );
                            }
                          : _startVerification,
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

  List<Widget> _buildCornerBrackets(bool success) {
    final color = success ? const Color(0xFF34D399) : const Color(0xFF4C8AFF);
    const size = 24.0;
    const thick = 2.5;

    return [
      Positioned(
        top: 16,
        left: 16,
        child: _Corner(
            color: color, size: size, thick: thick, top: true, left: true),
      ),
      Positioned(
        top: 16,
        right: 16,
        child: _Corner(
            color: color, size: size, thick: thick, top: true, left: false),
      ),
      Positioned(
        bottom: 16,
        left: 16,
        child: _Corner(
            color: color, size: size, thick: thick, top: false, left: true),
      ),
      Positioned(
        bottom: 16,
        right: 16,
        child: _Corner(
            color: color, size: size, thick: thick, top: false, left: false),
      ),
    ];
  }
}

class _Corner extends StatelessWidget {
  final Color color;
  final double size;
  final double thick;
  final bool top;
  final bool left;

  const _Corner({
    required this.color,
    required this.size,
    required this.thick,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter:
            _CornerPainter(color: color, thick: thick, top: top, left: left),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thick;
  final bool top;
  final bool left;

  _CornerPainter(
      {required this.color,
      required this.thick,
      required this.top,
      required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final x = left ? 0.0 : size.width;
    final y = top ? 0.0 : size.height;
    final xEnd = left ? size.width : 0.0;
    final yEnd = top ? size.height : 0.0;

    canvas.drawLine(Offset(x, y), Offset(xEnd, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, yEnd), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter o) => false;
}

// â”€â”€â”€ Primary button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PrimaryButton extends StatefulWidget {
  final String label;
  final bool loading;
  final bool isSuccess;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onTap,
    this.isSuccess = false,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!widget.loading) widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            gradient: widget.isSuccess
                ? const LinearGradient(
                    colors: [Color(0xFF34D399), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4C8AFF), Color(0xFF2048D4)],
                  ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (widget.isSuccess
                        ? const Color(0xFF34D399)
                        : const Color(0xFF3568F5))
                    .withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ Background orb painter â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
