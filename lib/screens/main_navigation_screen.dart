import 'package:flutter/material.dart';
import 'package:reloved/screens/home_screen.dart';
import 'package:reloved/screens/order_screen.dart';
import 'package:reloved/screens/profile_screen.dart';
import 'package:reloved/screens/add_product_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // hanya 3 screen karena index 1 (tombol +) tidak punya screen sendiri
  final List<Widget> _screens = [
    const HomeScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  // mapping index navbar ke index _screens
  // 0=Beranda, 1=Pesanan, 2=(tombol +, skip), 3=Profil
  void _onItemTapped(int index) {
    if (index == 2) {
      // tombol + → buka halaman jual sebagai bottom sheet atau push
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddProductScreen()),
      );
      return;
    }
    // mapping: 0→0, 1→1, 3→2
    final screenIndex = index < 2 ? index : index - 1;
    setState(() {
      _selectedIndex = screenIndex;
    });
  }

  // mapping balik dari _selectedIndex ke navbar index untuk currentIndex
  int get _navIndex {
    if (_selectedIndex < 2) return _selectedIndex;
    return _selectedIndex + 1; // skip index 2 (tombol +)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // Beranda
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Beranda',
                isActive: _navIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              // Pesanan
              _NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
                label: 'Pesanan',
                isActive: _navIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              // Tombol Jual Produk (tengah, menonjol)
              Expanded(
                child: GestureDetector(
                  onTap: () => _onItemTapped(2),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_box_outlined, color: Colors.grey, size: 24),
                      const SizedBox(height: 2),
                      const Text(
                        'Jual Produk',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Profil
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                isActive: _navIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? _primary : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? _primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}