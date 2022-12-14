import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavagationBar extends StatefulWidget {
  final int controller;
  final Function(int value) onChanged;
  final String? label;

  const NavagationBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.label,
  }) : super(key: key);

  @override
  State<NavagationBar> createState() => _NavagationBarState();
}

class _NavagationBarState extends State<NavagationBar> {
  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: widget.controller,
      onTap: (i) => widget.onChanged(i),
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: const Color(0xff7210FF),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.calendar_view_month_rounded),
          title: const Text("Bookings"),
          selectedColor: const Color(0xff7210FF),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.calendar_month_outlined),
          title: const Text("Calender"),
          selectedColor: const Color(0xff7210FF),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person_outline_rounded),
          title: const Text("Profile"),
          selectedColor: const Color(0xff7210FF),
        ),
      ],
    );
  }
}
