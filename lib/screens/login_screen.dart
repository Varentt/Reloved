import 'package:flutter/material.dart';
import 'package:reloved/screens/forgot_password_screen.dart';
import 'package:reloved/screens/main_navigation_screen.dart';
import 'package:reloved/screens/admin_dashboard_screen.dart';

// ── Mock user database (ganti dengan API call nanti) ──
const _mockUsers = [
  {'email': 'admin@reloved.com', 'password': 'admin123', 'role': 'admin',  'nama': 'Admin Reloved'},
  {'email': 'user@reloved.com',  'password': 'user123',  'role': 'user',   'nama': 'Pengguna'},
];

enum _AuthMode { login, register }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _AuthMode _mode = _AuthMode.login;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _emailLoginCtrl = TextEditingController();
  final _passLoginCtrl = TextEditingController();
  bool _rememberMe = false;
  bool _loginPassVisible = false;

  final _nameRegCtrl = TextEditingController();
  final _emailRegCtrl = TextEditingController();
  final _passRegCtrl = TextEditingController();
  bool _regPassVisible = false;

  @override
  void dispose() {
    _emailLoginCtrl.dispose();
    _passLoginCtrl.dispose();
    _nameRegCtrl.dispose();
    _emailRegCtrl.dispose();
    _passRegCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_loginFormKey.currentState!.validate()) return;

    final email    = _emailLoginCtrl.text.trim();
    final password = _passLoginCtrl.text;

    // ── Mock login: cari user di _mockUsers ──
    // TODO: ganti blok ini dengan API call ke backend nanti
    final matched = _mockUsers.where(
      (u) => u['email'] == email && u['password'] == password,
    ).toList();

    if (matched.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email atau password salah'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final role = matched.first['role'];
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  void _handleRegister() {
    if (!_registerFormKey.currentState!.validate()) return;

    // ── Mock register: langsung masuk sebagai pengguna ──
    // TODO: ganti dengan API call ke backend nanti
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil! Silakan masuk.'),
        backgroundColor: Color(0xFF3B5B8A),
      ),
    );
    _switchMode(_AuthMode.login);
  }

  void _switchMode(_AuthMode mode) => setState(() => _mode = mode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // WORKAROUND untuk bug _viewInsets.isNonNegative di Web
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mode Mobile
              return SingleChildScrollView(
                // Tambahkan padding bawah manual jika keyboard muncul di mobile
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 250,
                      child: _BrandPanel(),
                    ),
                    _buildFormPanel(isMobile: true),
                  ],
                ),
              );
            }
            // Mode Tablet/Web
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  flex: 4,
                  child: _BrandPanel(),
                ),
                Expanded(
                  flex: 6,
                  child: _buildFormPanel(isMobile: false),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormPanel({required bool isMobile}) {
    final formContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TabSwitcher(mode: _mode, onSwitch: _switchMode),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: _mode == _AuthMode.login
              ? _LoginForm(
                  key: const ValueKey('login'),
                  formKey: _loginFormKey,
                  emailCtrl: _emailLoginCtrl,
                  passCtrl: _passLoginCtrl,
                  rememberMe: _rememberMe,
                  onRememberChanged: (v) =>
                      setState(() => _rememberMe = v ?? false),
                  passVisible: _loginPassVisible,
                  onTogglePass: () => setState(
                      () => _loginPassVisible = !_loginPassVisible),
                  onForgotPassword: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen()),
                  ),
                  onSubmit: _handleLogin,
                  onSwitchToRegister: () =>
                      _switchMode(_AuthMode.register),
                )
              : _RegisterForm(
                  key: const ValueKey('register'),
                  formKey: _registerFormKey,
                  nameCtrl: _nameRegCtrl,
                  emailCtrl: _emailRegCtrl,
                  passCtrl: _passRegCtrl,
                  passVisible: _regPassVisible,
                  onTogglePass: () =>
                      setState(() => _regPassVisible = !_regPassVisible),
                  onSubmit: _handleRegister,
                  onSwitchToLogin: () => _switchMode(_AuthMode.login),
                ),
        ),
        const SizedBox(height: 120), // ruang biar tidak ketutup wave
      ],
    );

    final stack = Stack(
      children: [
        // Background putih
        Positioned.fill(child: Container(color: Colors.white)),
        
        // Dekorasi bawah: wave + floating icons
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 110,
            child: Stack(
              children: [
                CustomPaint(
                  painter: _FormWavePainter(),
                  child: const SizedBox.expand(),
                ),
                Positioned(bottom: 18, left: 24,  child: _FormFloatingIcon(Icons.checkroom,    30, opacity: 0.35)),
                Positioned(bottom: 40, left: 70,  child: _FormFloatingIcon(Icons.watch,        24, opacity: 0.25)),
                Positioned(bottom: 55, left: 130, child: _FormFloatingIcon(Icons.shopping_bag, 28, opacity: 0.30)),
                Positioned(bottom: 20, right: 90, child: _FormFloatingIcon(Icons.dry_cleaning, 26, opacity: 0.28)),
                Positioned(bottom: 48, right: 40, child: _FormFloatingIcon(Icons.card_giftcard,24, opacity: 0.22)),
                Positioned(bottom: 15, right: 20, child: _FormFloatingIcon(Icons.local_dining, 28, opacity: 0.30)),
              ],
            ),
          ),
        ),
        // Form content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: formContent,
        ),
      ],
    );

    if (isMobile) {
      return stack;
    } else {
      return Container(
        color: Colors.white,
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: stack,
        ),
      );
    }
  }
}

// ─────────────────────────────────────────
//  BRAND PANEL
// ─────────────────────────────────────────
class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
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

        // Floating preloved icons (scattered)
        Positioned(top: 18, left: 12,  child: _FloatingIcon(Icons.checkroom,       52, opacity: 0.18)),
        Positioned(top: 10, right: 10, child: _FloatingIcon(Icons.shopping_bag,     44, opacity: 0.15)),
        Positioned(top: 80, right: 8,  child: _FloatingIcon(Icons.watch,            38, opacity: 0.13)),
        Positioned(top: 120, left: 8,  child: _FloatingIcon(Icons.local_dining,     42, opacity: 0.16)),
        Positioned(top: 175, right: 14,child: _FloatingIcon(Icons.dry_cleaning,     36, opacity: 0.12)),
        Positioned(top: 220, left: 14, child: _FloatingIcon(Icons.directions_walk,   40, opacity: 0.15)),
        Positioned(top: 270, right: 6, child: _FloatingIcon(Icons.card_giftcard,    34, opacity: 0.13)),

        // Wave di kiri bawah
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            painter: _WavePainter(),
            child: const SizedBox(height: 100),
          ),
        ),

        // Branding — tengah panel
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD0E2F2).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFFD0E2F2),
                  size: 40,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Reloved',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Belanja Hemat,\nJual Lebih Manfaat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD0E2F2),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon(this.icon, this.size, {this.opacity = 0.15});
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

// Wave horizontal di pojok kiri bawah
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = Colors.white.withOpacity(0.15);
    final p2 = Paint()..color = Colors.white.withOpacity(0.25);

    final path1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.2, size.height * 0.1,
          size.width * 0.4, size.height * 0.45)
      ..quadraticBezierTo(
          size.width * 0.55, size.height * 0.7,
          size.width * 0.7, size.height * 0.4)
      ..quadraticBezierTo(
          size.width * 0.85, size.height * 0.15,
          size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path1, p1);

    final path2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.15, size.height * 0.35,
          size.width * 0.35, size.height * 0.65)
      ..quadraticBezierTo(
          size.width * 0.5, size.height * 0.85,
          size.width * 0.65, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.8, size.height * 0.4,
          size.width, size.height * 0.65)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path2, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Wave dekoratif untuk panel kanan (warna biru muda)
class _FormWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = const Color(0xFFD0E2F2).withOpacity(0.45);
    final p2 = Paint()..color = const Color(0xFFD0E2F2).withOpacity(0.70);

    final path1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.2, size.height * 0.1,
          size.width * 0.4, size.height * 0.45)
      ..quadraticBezierTo(
          size.width * 0.55, size.height * 0.7,
          size.width * 0.7, size.height * 0.4)
      ..quadraticBezierTo(
          size.width * 0.85, size.height * 0.15,
          size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path1, p1);

    final path2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.15, size.height * 0.35,
          size.width * 0.35, size.height * 0.65)
      ..quadraticBezierTo(
          size.width * 0.5, size.height * 0.85,
          size.width * 0.65, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.8, size.height * 0.4,
          size.width, size.height * 0.65)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path2, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FormFloatingIcon extends StatelessWidget {
  const _FormFloatingIcon(this.icon, this.size, {this.opacity = 0.3});
  final IconData icon;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: const Color(0xFF3B5B8A).withOpacity(opacity),
    );
  }
}

// ─────────────────────────────────────────
//  TAB SWITCHER
// ─────────────────────────────────────────
class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.mode, required this.onSwitch});
  final _AuthMode mode;
  final ValueChanged<_AuthMode> onSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFD0E2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Masuk',
            active: mode == _AuthMode.login,
            onTap: () => onSwitch(_AuthMode.login),
          ),
          _TabItem(
            label: 'Daftar',
            active: mode == _AuthMode.register,
            onTap: () => onSwitch(_AuthMode.register),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3B5B8A) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: active
                ? [
                    BoxShadow(
                        color: const Color(0xFF3B5B8A).withOpacity(0.25),
                        blurRadius: 8)
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : const Color(0xFF3B5B8A),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  INPUT HELPER
// ─────────────────────────────────────────
InputDecoration _inputDeco({
  required String label,
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFb0c4d8), fontSize: 13),
    labelStyle: const TextStyle(
        color: Color(0xFF3B5B8A), fontSize: 12, fontWeight: FontWeight.w700),
    prefixIcon: Icon(icon, color: const Color(0xFF7a8fa6), size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0xFFf7fbff),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD0E2F2), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF3B5B8A), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
  );
}

Widget _primaryButton(
    {required String label, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B5B8A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: Text(label,
          style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
    ),
  );
}

// ─────────────────────────────────────────
//  LOGIN FORM
// ─────────────────────────────────────────
class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.rememberMe,
    required this.onRememberChanged,
    required this.passVisible,
    required this.onTogglePass,
    required this.onForgotPassword,
    required this.onSubmit,
    required this.onSwitchToRegister,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberChanged;
  final bool passVisible;
  final VoidCallback onTogglePass;
  final VoidCallback onForgotPassword;
  final VoidCallback onSubmit;
  final VoidCallback onSwitchToRegister;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selamat Datang!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1a2535)),
          ),
          const SizedBox(height: 2),
          const Text(
            'Masuk untuk mulai belanja hemat',
            style: TextStyle(fontSize: 12, color: Color(0xFF7a8fa6)),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDeco(
              label: 'Email',
              hint: 'contoh@email.com',
              icon: Icons.email_outlined,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Email tidak boleh kosong';
              final reg = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!reg.hasMatch(v.trim())) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passCtrl,
            obscureText: !passVisible,
            decoration: _inputDeco(
              label: 'Password',
              hint: 'Masukkan password',
              icon: Icons.lock_outline,
              suffix: IconButton(
                icon: Icon(
                  passVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF7a8fa6),
                  size: 20,
                ),
                onPressed: onTogglePass,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
              if (v.length < 6) return 'Password minimal 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: onRememberChanged,
                    activeColor: const Color(0xFF3B5B8A),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  const Text('Ingat saya',
                      style:
                          TextStyle(fontSize: 12, color: Color(0xFF7a8fa6))),
                ],
              ),
              TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B5B8A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _primaryButton(label: 'Masuk', onPressed: onSubmit),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Belum punya akun? ',
                  style:
                      TextStyle(fontSize: 12, color: Color(0xFF7a8fa6))),
              GestureDetector(
                onTap: onSwitchToRegister,
                child: const Text(
                  'Daftar Sekarang',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B5B8A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  REGISTER FORM
// ─────────────────────────────────────────
class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.passVisible,
    required this.onTogglePass,
    required this.onSubmit,
    required this.onSwitchToLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool passVisible;
  final VoidCallback onTogglePass;
  final VoidCallback onSubmit;
  final VoidCallback onSwitchToLogin;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Buat Akun Baru',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1a2535)),
          ),
          const SizedBox(height: 2),
          const Text(
            'Bergabung dan mulai jual beli hari ini',
            style: TextStyle(fontSize: 12, color: Color(0xFF7a8fa6)),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDeco(
              label: 'Nama Lengkap',
              hint: 'Nama kamu',
              icon: Icons.person_outline,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Nama tidak boleh kosong';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDeco(
              label: 'Email',
              hint: 'contoh@email.com',
              icon: Icons.email_outlined,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Email tidak boleh kosong';
              final reg = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!reg.hasMatch(v.trim())) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passCtrl,
            obscureText: !passVisible,
            decoration: _inputDeco(
              label: 'Password',
              hint: 'Min. 6 karakter',
              icon: Icons.lock_outline,
              suffix: IconButton(
                icon: Icon(
                  passVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF7a8fa6),
                  size: 20,
                ),
                onPressed: onTogglePass,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
              if (v.length < 6) return 'Password minimal 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _primaryButton(label: 'Daftar', onPressed: onSubmit),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sudah punya akun? ',
                  style:
                      TextStyle(fontSize: 12, color: Color(0xFF7a8fa6))),
              GestureDetector(
                onTap: onSwitchToLogin,
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B5B8A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}