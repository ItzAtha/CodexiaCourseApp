import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Future<String> _loadPrivacyPolicyText() async {
    return await rootBundle.loadString('assets/privacy_policy.md');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy'), centerTitle: true, elevation: 0),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _loadPrivacyPolicyText(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading privacy policy: \n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Scrollbar(
                child: Markdown(
                  data: snapshot.data ?? 'No privacy policy available.',
                  padding: const EdgeInsets.all(16.0),
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                    h1: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.labelLarge?.color,
                    ),
                    h2: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    listBullet: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
