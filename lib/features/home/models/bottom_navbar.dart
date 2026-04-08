import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({
    super.key,
    required void Function(int) onItemSelected,
    required ValueNotifier<int> onItemSelectedNotifier,
  }) : _onItemSelectedNotifier = onItemSelectedNotifier,
       _onItemSelected = onItemSelected;

  final ValueChanged<int> _onItemSelected;
  final ValueNotifier<int> _onItemSelectedNotifier;

  @override
  State<StatefulWidget> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget._onItemSelectedNotifier,
      builder: (context, value, child) {
        selectedIndex.value = value;

        return BottomAppBar(
          color: Color(0xFF0984E3),
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.hardEdge,
          notchMargin: 8.0,
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              BottomNavbarItem(
                index: 0,
                currentIndex: selectedIndex,
                label: "Home",
                icon: Icons.home,
                onPress: (index) {
                  setState(() => selectedIndex.value = index);
                  widget._onItemSelected(index);
                },
              ).build(),
              BottomNavbarItem(
                index: 1,
                currentIndex: selectedIndex,
                label: "Course",
                icon: Icons.book,
                onPress: (index) {
                  setState(() => selectedIndex.value = index);
                  widget._onItemSelected(index);
                },
              ).build(),
              SizedBox(width: 15.0),
              BottomNavbarItem(
                index: 2,
                currentIndex: selectedIndex,
                label: "Community",
                icon: Icons.people,
                onPress: (index) {
                  setState(() => selectedIndex.value = index);
                  widget._onItemSelected(index);
                },
              ).build(),
              BottomNavbarItem(
                index: 3,
                currentIndex: selectedIndex,
                label: "Settings",
                icon: Icons.settings,
                onPress: (index) {
                  setState(() => selectedIndex.value = index);
                  widget._onItemSelected(index);
                },
              ).build(),
            ],
          ),
        );
      },
    );
  }
}

class BottomNavbarItem {
  final int index;
  final ValueNotifier<int> currentIndex;
  final String label;
  final IconData icon;
  final ValueChanged<int> onPress;

  BottomNavbarItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.onPress,
  });

  Widget build() {
    return Center(
      child: Container(
        width: 20,
        color: Colors.transparent,
        child: OverflowBox(
          maxWidth: 100,
          maxHeight: 60,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              onTap: () => onPress(index),
              child: ValueListenableBuilder(
                valueListenable: currentIndex,
                builder: (context, value, child) {
                  return AnimatedScale(
                    scale: value == index ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 70.0,
                      height: double.infinity,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 24,
                            color: value == index ? Color(0xFFF5F6FA) : Color(0xB3F5F6FA),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              color: value == index ? Color(0xFFF5F6FA) : Color(0xB3F5F6FA),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
