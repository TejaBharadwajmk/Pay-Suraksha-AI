import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'CreatePinScreen.dart';

// â”€â”€â”€ CreateProfileScreen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbCtrl;
  late AnimationController _enterCtrl;
  late Animation<double> _fade;
  late Animation<double> _slide;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool get _canContinue =>
      _nameCtrl.text.trim().isNotEmpty && _emailCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _orbCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );
    _enterCtrl.forward();
    _nameCtrl.addListener(() => setState(() {}));
    _emailCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _enterCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
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
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
                    offset: Offset(0, _slide.value), child: child),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Back + title row
                    Row(
                      children: [
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
                        const SizedBox(width: 14),
                        const Text(
                          "Create Profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Avatar picker
                    Center(
                      child: GestureDetector(
                        onTap: () => _showSnack("â†’ Open image picker"),
                        child: AnimatedBuilder(
                          animation: _orbCtrl,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(
                                0, math.sin(_orbCtrl.value * math.pi * 2) * 5),
                            child: child,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1E2E50),
                                      Color(0xFF0D1525)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF3568F5)
                                        .withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF3568F5)
                                          .withValues(alpha: 0.25),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 48,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4C8AFF),
                                        Color(0xFF2048D4)
                                      ],
                                    ),
                                  ),
                                  child: const Icon(Icons.add_a_photo_rounded,
                                      size: 15, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Tap to upload photo",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.3)),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Name field
                    _InputField(
                      controller: _nameCtrl,
                      focusNode: _nameFocus,
                      label: "Full Name",
                      hint: "Enter your name",
                      icon: Icons.person_outline_rounded,
                      nextFocus: _emailFocus,
                    ),

                    const SizedBox(height: 16),

                    // Email field
                    _InputField(
                      controller: _emailCtrl,
                      focusNode: _emailFocus,
                      label: "Email Address",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      isLast: true,
                    ),

                    const SizedBox(height: 40),

                    // Continue button
                    _PrimaryButton(
                      label: "Continue",
                      enabled: _canContinue,
                      onTap: () {
                        if (_canContinue) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreatePinScreen(),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 40),
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

// â”€â”€â”€ Input field â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _InputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final FocusNode? nextFocus;
  final bool isLast;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.nextFocus,
    this.isLast = false,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final focused = widget.focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.45),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focused
                  ? const Color(0xFF3568F5)
                  : Colors.white.withValues(alpha: 0.1),
              width: focused ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            textInputAction:
                widget.isLast ? TextInputAction.done : TextInputAction.next,
            onSubmitted: (_) {
              if (widget.nextFocus != null) widget.nextFocus!.requestFocus();
            },
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintText: widget.hint,
              hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.2), fontSize: 15),
              prefixIcon: Icon(widget.icon,
                  color: focused
                      ? const Color(0xFF4C8AFF)
                      : Colors.white.withValues(alpha: 0.25),
                  size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€ Primary button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PrimaryButton extends StatefulWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _PrimaryButton(
      {required this.label, required this.enabled, required this.onTap});

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
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            gradient: widget.enabled
                ? const LinearGradient(
                    colors: [Color(0xFF4C8AFF), Color(0xFF2048D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.enabled ? null : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: widget.enabled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                        color: const Color(0xFF3568F5).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: widget.enabled
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
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
