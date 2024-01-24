import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          unselectedFontSize: 12,
          selectedFontSize: 12,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Athletes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.label),
              label: 'Medals',
            ),
          ],
        ),
      );
}
