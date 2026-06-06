import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reloved/screens/login_screen.dart';
import 'package:reloved/utils/color_resources.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();

    // Logo: scale + fade
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    // Teks: fade + slide dari bawah
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Progress bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Urutan animasi
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _progressController.forward();
    });

    // Navigasi ke LoginScreen setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2e4a73),
                  Color(0xFF3B5B8A),
                  Color(0xFF4a6fa0),
                ],
              ),
            ),
          ),

          // Floating icons dekoratif
          Positioned(top: 60,  left: 24,  child: _FloatingIcon(Icons.checkroom,       64, opacity: 0.10)),
          Positioned(top: 40,  right: 30, child: _FloatingIcon(Icons.shopping_bag,    52, opacity: 0.08)),
          Positioned(top: 160, right: 20, child: _FloatingIcon(Icons.watch,           44, opacity: 0.09)),
          Positioned(top: 220, left: 16,  child: _FloatingIcon(Icons.dry_cleaning,    50, opacity: 0.08)),
          Positioned(top: 300, right: 40, child: _FloatingIcon(Icons.card_giftcard,   42, opacity: 0.10)),
          Positioned(bottom: 180, left: 30,  child: _FloatingIcon(Icons.local_dining,    48, opacity: 0.09)),
          Positioned(bottom: 140, right: 20, child: _FloatingIcon(Icons.directions_walk, 44, opacity: 0.08)),
          Positioned(bottom: 260, left: 60,  child: _FloatingIcon(Icons.sell,            38, opacity: 0.07)),

          // Wave bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: _SplashWavePainter(),
              child: const SizedBox(height: 130),
            ),
          ),

          // Konten utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD0E2F2).withOpacity(0.5),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 56,
                        color: Color(0xFFD0E2F2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Teks
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        const Text(
                          'Reloved',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Belanja Hemat, Jual Lebih Manfaat',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFD0E2F2),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Progress bar animasi
                FadeTransition(
                  opacity: _textFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _progressValue,
                          builder: (context, _) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _progressValue.value,
                                minHeight: 4,
                                backgroundColor:
                                    Colors.white.withOpacity(0.2),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Color(0xFFD0E2F2)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon(this.icon, this.size, {this.opacity = 0.10});
  final IconData icon;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: const Color(0xFFD0E2F2).withOpacity(opacity),
    );
  }
}

class _SplashWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = Colors.white.withOpacity(0.07);
    final p2 = Paint()..color = Colors.white.withOpacity(0.12);

    final path1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.1,
          size.width * 0.4, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.7,
          size.width * 0.7, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.15,
          size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path1, p1);

    final path2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.35,
          size.width * 0.35, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.85,
          size.width * 0.65, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.4,
          size.width, size.height * 0.65)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path2, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}