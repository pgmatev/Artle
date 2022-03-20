import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  final PageController pageController = PageController(
    initialPage: 1,
  );

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 1;

  void onTappedBar(int value) {
    _currentIndex = value;
    widget.pageController.animateToPage(
      value,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        iconSize: 22,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Payments",
            activeIcon: Icon(Icons.access_time_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Account",
            activeIcon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}