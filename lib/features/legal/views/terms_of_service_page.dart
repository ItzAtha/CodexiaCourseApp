import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  Future<String> _loadTermsText() async {
    return await rootBundle.loadString('assets/tos.md');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service'), centerTitle: true, elevation: 0),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _loadTermsText(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading terms: \n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Scrollbar(
                child: Markdown(
                  data: snapshot.data ?? 'No terms available.',
                  padding: const EdgeInsets.all(16.0),
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, height: 1.5),
                    h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
