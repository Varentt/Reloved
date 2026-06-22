import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/chat_service.dart';
import 'package:reloved/screens/home_screen.dart';
import 'package:reloved/screens/order_screen.dart';
import 'package:reloved/screens/profile_screen.dart';
import 'package:reloved/screens/add_product_screen.dart';
import 'package:reloved/screens/chat_list_screen.dart';
import 'package:reloved/screens/favorite_screen.dart';

const _primary = Color(0xFF3B5B8A);

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const OrderScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
    const FavoriteScreen(),
  ];

  // mapping index navbar ke index _screens
  // 0=Beranda, 1=Pesanan, 2=Chat, 3=Jual Produk (skip/push), 4=Profil
  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddProductScreen()),
      );
      return;
    }
    final screenIndex = index < 3 ? index : index - 1;
    setState(() {
      _selectedIndex = screenIndex;
    });
  }

  // mapping balik dari _selectedIndex ke navbar index untuk currentIndex
  int get _navIndex {
    if (_selectedIndex < 3) return _selectedIndex;
    return _selectedIndex + 1; // skip index 3 (Jual Produk)
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final myUser = authProvider.user;

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
              _NavItem(
                icon: Icons.favorite_border_outlined,
                activeIcon: Icons.favorite_border,
                label: 'Favorit',
                isActive: _navIndex == 5,
                onTap: () => _onItemTapped(5),
              ),
              // Chat
              myUser == null
                  ? _NavItem(
                      icon: Icons.chat_bubble_outline,
                      activeIcon: Icons.chat_bubble,
                      label: 'Chat',
                      isActive: _navIndex == 2,
                      onTap: () => _onItemTapped(2),
                    )
                  : StreamBuilder<List<ChatRoomModel>>(
                      stream: ChatService().getUserChatRooms(myUser.uid),
                      builder: (context, snapshot) {
                        final rooms = snapshot.data ?? [];
                        final unreadRoomsCount = rooms.where((room) {
                          final count = room.unreadCount[myUser.uid] ?? 0;
                          return count > 0;
                        }).length;

                        return _NavItem(
                          icon: Icons.chat_bubble_outline,
                          activeIcon: Icons.chat_bubble,
                          label: 'Chat',
                          isActive: _navIndex == 2,
                          onTap: () => _onItemTapped(2),
                          badgeCount: unreadRoomsCount,
                        );
                      },
                    ),
              // Tombol Jual Produk (menonjol)
              Expanded(
                child: GestureDetector(
                  onTap: () => _onItemTapped(3),
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
                isActive: _navIndex == 4,
                onTap: () => _onItemTapped(4),
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
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? _primary : Colors.grey,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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