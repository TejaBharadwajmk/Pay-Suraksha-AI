import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:guardpay_ai/screens/DashboardScreen.dart';

// â”€â”€â”€ CreatePinScreen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Handles both "Create PIN" (step 1) and "Confirm PIN" (step 2) in one widget

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late AnimationController _enterCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _successCtrl;

  late Animation<double> _fade;
  late Animation<double> _slide;
  late Animation<double> _shake;
  late Animation<double> _successScale;

  // Step 1 = create, Step 2 = confirm
  int _step = 1;
  String _pin = '';
  String _confirmedPin = '';
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _orbCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _successCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 30, end: 0).animate(
        CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _shake = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));
    _successScale = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut));

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _enterCtrl.dispose();
    _shakeCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  String get _currentPin => _step == 1 ? _pin : _confirmedPin;

  void _onKey(String digit) {
    if (_currentPin.length >= 6) return;
    setState(() {
      _error = false;
      if (_step == 1) {
        _pin += digit;
      } else {
        _confirmedPin += digit;
      }
    });

    if (_currentPin.length == 6) {
      _onComplete();
    }
  }

  void _onDelete() {
    if (_currentPin.isEmpty) return;
    setState(() {
      _error = false;
      if (_step == 1) {
        _pin = _pin.substring(0, _pin.length - 1);
      } else {
        _confirmedPin = _confirmedPin.substring(0, _confirmedPin.length - 1);
      }
    });
  }

  Future<void> _onComplete() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (_step == 1) {
      // Move to confirm step
      setState(() {
        _step = 2;
        _confirmedPin = '';
      });
      _enterCtrl.forward(from: 0);
    } else {
      // Verify PINs match
      if (_pin == _confirmedPin) {
        _successCtrl.forward(from: 0);
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      } else {
        _shakeCtrl.forward(from: 0);
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _error = true;
          _confirmedPin = '';
        });
        _showSnack("PINs don't match. Try again.");
      }
    }
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // â”€â”€ Back button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                        GestureDetector(
                          onTap: () {
                            if (_step == 2) {
                              setState(() {
                                _step = 1;
                                _pin = '';
                                _confirmedPin = '';
                                _error = false;
                              });
                            } else {
                              Navigator.maybePop(context);
                            }
                          },
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

                        const SizedBox(height: 36),

                        // â”€â”€ Title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            key: ValueKey(_step),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _step == 1 ? "Create PIN" : "Confirm PIN",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _step == 1
                                    ? "Set a 6-digit PIN to secure your account"
                                    : "Re-enter your PIN to confirm",
                                style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.white.withValues(alpha: 0.4)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // â”€â”€ PIN dots â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                        AnimatedBuilder(
                          animation:
                              Listenable.merge([_shakeCtrl, _successCtrl]),
                          builder: (_, __) {
                            return Transform.translate(
                              offset: Offset(
                                  math.sin(_shake.value * math.pi * 8) * 10, 0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(6, (i) {
                                    final filled = i < _currentPin.length;
                                    final isSuccess = _pin == _confirmedPin &&
                                        _step == 2 &&
                                        filled;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: filled
                                            ? (_error
                                                ? const Color(0xFFEF4444)
                                                : isSuccess
                                                    ? const Color(0xFF34D399)
                                                    : const Color(0xFF3568F5))
                                            : Colors.white
                                                .withValues(alpha: 0.12),
                                        boxShadow: filled
                                            ? [
                                                BoxShadow(
                                                  color: (_error
                                                          ? const Color(
                                                              0xFFEF4444)
                                                          : const Color(
                                                              0xFF3568F5))
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 8,
                                                  spreadRadius: 1,
                                                )
                                              ]
                                            : null,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        ),

                        if (_error) ...[
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              "PINs don't match. Try again.",
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: const Color(0xFFEF4444)
                                      .withValues(alpha: 0.85)),
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // â”€â”€ Numpad â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumRow(keys: const ['1', '2', '3'], onTap: _onKey),
                          const SizedBox(height: 12),
                          _NumRow(keys: const ['4', '5', '6'], onTap: _onKey),
                          const SizedBox(height: 12),
                          _NumRow(keys: const ['7', '8', '9'], onTap: _onKey),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Empty spacer
                              const SizedBox(width: 80, height: 64),
                              // 0
                              _NumKey(label: '0', onTap: () => _onKey('0')),
                              // Delete
                              _DeleteKey(onTap: _onDelete),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Continue button
                          _ContinueButton(
                            enabled: _currentPin.length == 6,
                            onTap:
                                _currentPin.length == 6 ? _onComplete : () {},
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Num row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _NumRow extends StatelessWidget {
  final List<String> keys;
  final ValueChanged<String> onTap;

  const _NumRow({required this.keys, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          keys.map((k) => _NumKey(label: k, onTap: () => onTap(k))).toList(),
    );
  }
}

// â”€â”€â”€ Num key â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _NumKey extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NumKey({required this.label, required this.onTap});

  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 80,
        height: 64,
        decoration: BoxDecoration(
          color: _pressed
              ? const Color(0xFF3568F5).withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed
                ? const Color(0xFF3568F5).withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: _pressed ? 1.0 : 0.85),
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ Delete key â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DeleteKey extends StatefulWidget {
  final VoidCallback onTap;
  const _DeleteKey({required this.onTap});

  @override
  State<_DeleteKey> createState() => _DeleteKeyState();
}

class _DeleteKeyState extends State<_DeleteKey> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 80,
        height: 64,
        decoration: BoxDecoration(
          color: _pressed
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.white.withValues(alpha: 0.5),
            size: 22,
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ Continue button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ContinueButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _ContinueButton({required this.enabled, required this.onTap});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
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
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: widget.enabled
                ? const LinearGradient(
                    colors: [Color(0xFF4C8AFF), Color(0xFF2048D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                : null,
            color: widget.enabled ? null : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: widget.enabled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                        color: const Color(0xFF3568F5).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6))
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              "Continue",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: widget.enabled
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.25),
                letterSpacing: 0.3,
              ),
            ),
          ),
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
