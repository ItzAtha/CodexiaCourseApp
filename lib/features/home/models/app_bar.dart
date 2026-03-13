import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x800984E3), Color(0xFF0984E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withValues(alpha: 0.5),
            blurRadius: 10.0,
            offset: const Offset(0, 8.0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "Welcome Back,",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFFF5F6FA),
                          ),
                        ),
                        Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF5F6FA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      // Handle notification tap
                      print("Notification tapped");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCFBFB),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.notifications,
                              size: 20.0,
                              color: Colors.blue,
                            ),
                            Positioned(
                              top: 1.0,
                              right: 2.0,
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
