// lib/widgets/floating_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/home_page.dart';
import 'package:roc_vooraadbeheersysteem/pages/test_page.dart';
import 'package:roc_vooraadbeheersysteem/pages/archive_page.dart';
import 'package:roc_vooraadbeheersysteem/pages/item_page.dart';
import 'package:roc_vooraadbeheersysteem/pages/student_page.dart';
import 'package:roc_vooraadbeheersysteem/pages/tables_page.dart';

class FloatingNavBar extends StatefulWidget {
  const FloatingNavBar({Key? key}) : super(key: key);

  @override
  _FloatingNavBarState createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  bool _isOpen = false;

  void _toggleNavBar() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _navigateTo(String routeName) {
    // Close the navbar before navigating
    _toggleNavBar();

    // Add a delay to allow the navbar to close before navigating
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              _getPageByRouteName(routeName),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  Widget _getPageByRouteName(String routeName) {
    switch (routeName) {
      case '/home':
        return HomePage();
      case '/test':
        return TestPage();
      case '/archive':
        return ArchivePage();
      case '/item':
        return ItemPage();
      case '/student':
        return StudentPage();
      case '/tables':
        return TablesPage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Slide the navbar in and out without opacity change
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _isOpen ? 0 : -220, // Slide the navbar in and out
          top: 0,
          bottom: 0,
          child: Container(
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xfffF0f0f7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  color: const Color(0xff6E6EB4),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'Navigation',
                    style: TextStyle(
                      color: const Color(0xfff0f0f7),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Color(0xff3f2e56)),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Color(0xff3f2e56)),
                  ),
                  onTap: () {
                    _navigateTo('/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pageview, color: Color(0xff3f2e56)),
                  title: const Text(
                    'Test Page',
                    style: TextStyle(color: Color(0xff3f2e56)),
                  ),
                  onTap: () {
                    _navigateTo('/test');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive, color: Color(0xff3f2e56)),
                  title: const Text(
                    'Archive',
                    style: TextStyle(color: Color(0xff3f2e56)),
                  ),
                  onTap: () {
                    _navigateTo('/archive');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list, color: Color(0xff3f2e56)),
                  title: const Text(
                    'Item',
                    style: TextStyle(color: Color(0xff3f2e56)),
                  ),
                  onTap: () {
                    _navigateTo('/item');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xff3f2e56)),
                  title: const Text(
                    'Students',
                    style: TextStyle(color: Color(0xff3f2e56)),
                  ),
                  onTap: () {
                    _navigateTo('/student');
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.table_chart, color: Color(0xff3f2e56)),
                  title: const Text(
                    'Table',
                    style: TextStyle(color: Color(0xff3f2e56)),
                  ),
                  onTap: () {
                    _navigateTo('/tables');
                  },
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: Text(
                      'Version 1.0',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Animate the button position
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _isOpen ? 220 : 0, // Move the button according to navbar state
          top: 0,
          child: GestureDetector(
            onTap: _toggleNavBar,
            child: Container(
              width: 45,
              height: 60, // Set the desired height here
              decoration: BoxDecoration(
                color: const Color(0xff6e6eb4),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(
                _isOpen ? Icons.close : Icons.menu,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
