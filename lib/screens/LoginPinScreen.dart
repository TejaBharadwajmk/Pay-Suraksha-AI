// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'FaceVerifyLoginScreen.dart';
import 'ForgotPinScreen.dart';

// â”€â”€â”€ LoginPinScreen (Screen 2d) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// User enters their previously created 6-digit PIN
// Correct PIN â†’ FaceVerifyLoginScreen
// Forgot PIN  â†’ ForgotPinFaceScreen

class LoginPinScreen extends StatefulWidget {
  const LoginPinScreen({super.key});

  @override
  State<LoginPinScreen> createState() => _LoginPinScreenState();
}

class _LoginPinScreenState extends State<LoginPinScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late AnimationController _enterCtrl;
  late AnimationController _shakeCtrl;

  late Animation<double> _fade;
  late Animation<double> _slide;
  late Animation<double> _shake;

  String _pin = '';
  bool _error = false;
  bool _loading = false;

  // Brute-force lockout
  int _failedAttempts = 0;
  static const int _maxAttempts = 5;
  bool _isLockedOut = false;
  int _lockoutSeconds = 0;
  Timer? _lockoutTimer;

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

    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );
    _shake = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _enterCtrl.dispose();
    _shakeCtrl.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  void _onKey(String digit) {
    if (_isLockedOut || _pin.length >= 6 || _loading) return;
    setState(() {
      _error = false;
      _pin += digit;
    });
    if (_pin.length == 6) _verifyPin();
  }

  void _onDelete() {
    if (_isLockedOut || _pin.isEmpty || _loading) return;
    setState(() {
      _error = false;
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  Future<void> _verifyPin() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: SecurityService.verifyPin(_pin)
    const bool pinCorrect = true;

    setState(() => _loading = false);

    if (pinCorrect) {
      _failedAttempts = 0;
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const FaceVerifyLoginScreen()));
    // ignore: dead_code
    } else {
      _failedAttempts++;
      _shakeCtrl.forward(from: 0);
      setState(() {
        _error = true;
        _pin = '';
      });
      if (_failedAttempts >= _maxAttempts) {
        _startLockout();
      } else {
        _showSnack(
            "Wrong PIN. ${_maxAttempts - _failedAttempts} attempt(s) left.",
            isError: true);
      }
    }
  }

  void _startLockout() {
    final seconds = [30, 60, 120, 300];
    _lockoutSeconds =
        seconds[(_failedAttempts - _maxAttempts).clamp(0, seconds.length - 1)];
    setState(() => _isLockedOut = true);
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_lockoutSeconds <= 0) {
        t.cancel();
        setState(() {
          _isLockedOut = false;
          _pin = '';
          _error = false;
        });
      } else {
        setState(() => _lockoutSeconds--);
      }
    });
    _showSnack("Too many attempts. Try again in ${_lockoutSeconds}s.",
        isError: true);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13)),
      backgroundColor:
          isError ? const Color(0xFF7F1D1D) : const Color(0xFF1A2540),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 3),
    ));
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

                        const SizedBox(height: 36),

                        // Lock icon
                        AnimatedBuilder(
                          animation: _orbCtrl,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(
                                0, math.sin(_orbCtrl.value * math.pi * 2) * 5),
                            child: child,
                          ),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3568F5), Color(0xFF1235B0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF3568F5)
                                        .withValues(alpha: 0.38),
                                    blurRadius: 24,
                                    spreadRadius: 2)
                              ],
                            ),
                            child: const Icon(Icons.lock_rounded,
                                color: Colors.white, size: 26),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Title
                        const Text(
                          "Enter your\nprevious PIN",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -1.0,
                              height: 1.2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLockedOut
                              ? "Account locked. Try again in ${_lockoutSeconds}s"
                              : "Enter the 6-digit PIN you created earlier",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: _isLockedOut
                                ? const Color(0xFFEF4444).withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.4),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // PIN dots
                        AnimatedBuilder(
                          animation: _shakeCtrl,
                          builder: (_, __) => Transform.translate(
                            offset: Offset(
                                math.sin(_shake.value * math.pi * 8) * 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (i) {
                                final filled = i < _pin.length;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: filled
                                        ? (_error
                                            ? const Color(0xFFEF4444)
                                            : const Color(0xFF3568F5))
                                        : Colors.white.withValues(alpha: 0.12),
                                    boxShadow: filled
                                        ? [
                                            BoxShadow(
                                              color: (_error
                                                      ? const Color(0xFFEF4444)
                                                      : const Color(0xFF3568F5))
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
                        ),

                        const SizedBox(height: 16),

                        // Forgot PIN
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPinFaceScreen())),
                            child: Text(
                              "Forgot PIN?",
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFF4C8AFF)
                                    .withValues(alpha: 0.8),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFF4C8AFF)
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // Numpad
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumRow(
                              keys: const ['1', '2', '3'],
                              onTap: _onKey,
                              disabled: _isLockedOut),
                          const SizedBox(height: 12),
                          _NumRow(
                              keys: const ['4', '5', '6'],
                              onTap: _onKey,
                              disabled: _isLockedOut),
                          const SizedBox(height: 12),
                          _NumRow(
                              keys: const ['7', '8', '9'],
                              onTap: _onKey,
                              disabled: _isLockedOut),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 80, height: 64),
                              _NumKey(
                                  label: '0',
                                  onTap: () => _onKey('0'),
                                  disabled: _isLockedOut),
                              _DeleteKey(
                                  onTap: _onDelete, disabled: _isLockedOut),
                            ],
                          ),
                          const SizedBox(height: 20),
                        _ActionButton(
                            label: "Verify PIN",
                            loading: _loading,
                            enabled: _pin.length == 6 && !_isLockedOut,
                            onTap: _pin.length == 6 ? _verifyPin : () {},
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

// â”€â”€â”€ Shared widgets (numpad) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _NumRow extends StatelessWidget {
  final List<String> keys;
  final ValueChanged<String> onTap;
  final bool disabled;
  const _NumRow(
      {required this.keys, required this.onTap, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys
          .map((k) =>
              _NumKey(label: k, onTap: () => onTap(k), disabled: disabled))
          .toList(),
    );
  }
}

class _NumKey extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool disabled;
  const _NumKey(
      {required this.label, required this.onTap, this.disabled = false});

  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.disabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 80,
        height: 64,
        decoration: BoxDecoration(
          color: widget.disabled
              ? Colors.white.withValues(alpha: 0.02)
              : _pressed
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
          child: Text(widget.label,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(
                      alpha: widget.disabled ? 0.2 : (_pressed ? 1.0 : 0.85)))),
        ),
      ),
    );
  }
}

class _DeleteKey extends StatefulWidget {
  final VoidCallback onTap;
  final bool disabled;
  const _DeleteKey({required this.onTap, this.disabled = false});

  @override
  State<_DeleteKey> createState() => _DeleteKeyState();
}

class _DeleteKeyState extends State<_DeleteKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.disabled
          ? null
          : (_) {
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
          child: Icon(Icons.backspace_outlined,
              color:
                  Colors.white.withValues(alpha: widget.disabled ? 0.15 : 0.5),
              size: 22),
        ),
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

  const _ActionButton({
    this.isSuccess = false,
    required this.label,
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

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
