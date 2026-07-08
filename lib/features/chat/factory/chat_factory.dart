import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatFactory {
  final String message;

  ChatFactory({required this.message});

  List<InlineSpan> format() {
    final lineSplitter = RegExp(r'\r?\n');
    final headerRegex = RegExp(r'^(#+)\s*(.*)$');
    final listMarkerRegex = RegExp(r'^(\s*(\*|-|\d+\.)\s+)');

    List<InlineSpan> separateSpanText = [];
    List<String> separateLines = message.split(lineSplitter);

    for (int i = 0; i < separateLines.length; i++) {
      String line = separateLines[i];

      if (line.trim().isEmpty) {
        separateSpanText.add(const TextSpan(text: '\n'));
        continue;
      }

      final headerMatch = headerRegex.firstMatch(line);
      if (headerMatch != null) {
        String hashes = headerMatch.group(1)!;
        String content = headerMatch.group(2)!;
        int hashCount = hashes.length;

        double fontSize;
        switch (hashCount) {
          case 1:
            fontSize = 20.0;
            break;
          case 2:
            fontSize = 18.0;
            break;
          default:
            fontSize = 16.0;
        }

        separateSpanText.add(
          TextSpan(
            text: content,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        );
        if (i < separateLines.length - 1) {
          separateSpanText.add(const TextSpan(text: '\n'));
        }
        continue;
      }

      if (line == "---") {
        continue;
      }

      List<InlineSpan> lineSpans = [];

      final listMatch = listMarkerRegex.firstMatch(line);
      String textToParse = line;
      if (listMatch != null) {
        String marker = listMatch.group(1)!;
        lineSpans.add(TextSpan(text: marker));
        textToParse = line.substring(marker.length);
      }

      lineSpans.addAll(_parseInline(textToParse));

      separateSpanText.add(TextSpan(children: lineSpans, style: const TextStyle(fontSize: 16.0)));

      if (i < separateLines.length - 1) {
        separateSpanText.add(const TextSpan(text: '\n'));
      }
    }

    return separateSpanText;
  }

  List<InlineSpan> _parseInline(String text) {
    final linkRegex = RegExp(r'\[(.*?)\]\((.*?)\)', dotAll: true);
    final boldRegex = RegExp(r'\*\*(.*?)\*\*', dotAll: true);
    final italicRegex = RegExp(r'\*(.*?)\*', dotAll: true);
    final codeRegex = RegExp(r'`(.*?)`', dotAll: true);

    List<InlineSpan> spans = [];
    int cursor = 0;

    while (cursor < text.length) {
      final linkMatch = linkRegex.firstMatch(text.substring(cursor));
      final boldMatch = boldRegex.firstMatch(text.substring(cursor));
      final italicMatch = italicRegex.firstMatch(text.substring(cursor));
      final codeMatch = codeRegex.firstMatch(text.substring(cursor));

      int earliestIndex = -1;
      Match? bestMatch;
      String type = '';

      void updateBest(Match? m, String t) {
        if (m != null) {
          if (earliestIndex == -1 || m.start < earliestIndex) {
            earliestIndex = m.start;
            bestMatch = m;
            type = t;
          } else if (m.start == earliestIndex) {
            const priorities = {'link': 0, 'bold': 1, 'italic': 2, 'code': 3};
            if (priorities[t]! < priorities[type]!) {
              bestMatch = m;
              type = t;
            }
          }
        }
      }

      updateBest(linkMatch, 'link');
      updateBest(boldMatch, 'bold');
      updateBest(italicMatch, 'italic');
      updateBest(codeMatch, 'code');

      if (bestMatch == null) {
        spans.add(TextSpan(text: text.substring(cursor)));
        break;
      }

      if (bestMatch!.start > 0) {
        spans.add(TextSpan(text: text.substring(cursor, cursor + bestMatch!.start)));
      }

      int matchEnd = cursor + bestMatch!.end;
      if (type == 'link') {
        String linkText = bestMatch!.group(1) ?? '';
        String url = bestMatch!.group(2) ?? '';
        spans.add(
          TextSpan(
            children: _parseInline(linkText),
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
          ),
        );
      } else if (type == 'bold') {
        String content = bestMatch!.group(1) ?? '';
        spans.add(
          TextSpan(
            children: _parseInline(content),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else if (type == 'italic') {
        String content = bestMatch!.group(1) ?? '';
        spans.add(
          TextSpan(
            children: _parseInline(content),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (type == 'code') {
        String content = bestMatch!.group(1) ?? '';
        spans.add(
          TextSpan(
            text: content,
            style: TextStyle(
              fontFamily: 'monospace',
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
            ),
          ),
        );
      }

      cursor = matchEnd;
    }

    return spans;
  }
}
