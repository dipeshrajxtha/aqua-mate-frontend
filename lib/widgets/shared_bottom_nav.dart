import 'package:flutter/material.dart';
import 'package:aqua_mate/routes/app_routes.dart';

class SharedBottomNav extends StatelessWidget {
  final int currentIndex; // tells which tab is active

  const SharedBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: const Color(0xFF4ade80),
          unselectedItemColor: Colors.grey[500],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          onTap: (index) {
            if (index == currentIndex) return; // avoid reload

            switch (index) {
              case 0:
                Navigator.pushNamed(context, AppRoutes.maintenance);
                break;
              case 1:
                Navigator.pushNamed(context, AppRoutes.dashboard);
                break;
              case 2:
                Navigator.pushNamed(context, AppRoutes.library);
                break;
              case 3:
                Navigator.pushNamed(context, AppRoutes.settings);
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined),
              label: 'Maintenance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}