import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<StatefulWidget> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Text(
          "Community Page Content",
          style: TextStyle(fontSize: 20.0, color: Theme.of(context).textTheme.labelMedium?.color),
        ),
      ),
    );
  }
}
