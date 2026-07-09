import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_constants.dart' show AppSizes, AppColors;

class ChatFactory {
  final BuildContext context;
  final String message;

  ChatFactory({required this.context, required this.message});

  List<InlineSpan> format() {
    final lineSplitter = RegExp(r'\r?\n');
    final headerRegex = RegExp(r'^(#+)\s*(.*)$');
    final listMarkerRegex = RegExp(r'^(\s*(\*|-|\d+\.)\s+)');

    List<InlineSpan> separateSpanText = [];
    List<String> separateLines = message.split(lineSplitter);

    for (int i = 0; i < separateLines.length; i++) {
      String line = separateLines[i];

      if (line.trim().startsWith('```')) {
        String language = line.trim().substring(3).trim();
        List<String> codeLines = [];
        i++;

        while (i < separateLines.length && !separateLines[i].trim().startsWith('```')) {
          final linkSyntaxRegex = RegExp(r'\[(.*?)\]\(.*?\)');
          String cleanedLine = separateLines[i].replaceAllMapped(
            linkSyntaxRegex,
            (match) => match.group(1) ?? '',
          );
          final otherSymbolsRegex = RegExp(r'\*\*|\*|`|#');
          cleanedLine = cleanedLine.replaceAll(otherSymbolsRegex, '');

          codeLines.add(cleanedLine);
          i++;
        }

        String fullCode = codeLines.join('\n').trimLeft();
        final ScrollController scrollController = ScrollController();

        separateSpanText.add(
          WidgetSpan(
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2D31),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p12,
                      vertical: AppSizes.p8 / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          language.isNotEmpty ? language.capitalize() : "Text",
                          style: GoogleFonts.jetBrainsMono(
                            textStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: fullCode));

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Text copied to clipboard!"),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                              snackBarAnimationStyle: const AnimationStyle(
                                duration: Duration(milliseconds: 600),
                                reverseDuration: Duration(milliseconds: 600),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, color: AppColors.secondary),
                          iconSize: 16.0,
                          padding: const EdgeInsets.all(AppSizes.p12),
                          constraints: const BoxConstraints(),
                          style: IconButton.styleFrom(backgroundColor: const Color(0xFF2B2D31)),
                        ),
                      ],
                    ),
                  ),
                  RawScrollbar(
                    controller: scrollController,
                    radius: const Radius.circular(8.0),
                    thumbColor: AppColors.secondary,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: HighlightView(
                        fullCode,
                        language: language.isNotEmpty ? language : null,
                        theme: atomOneDarkTheme,
                        textStyle: GoogleFonts.firaCode(textStyle: const TextStyle(fontSize: 14.0)),
                        padding: const EdgeInsets.all(AppSizes.p12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        if (i < separateLines.length - 1) {
          separateSpanText.add(const TextSpan(text: '\n'));
        }
        continue;
      }

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
            text: content.replaceAll(RegExp(r'\*\*|\*|`'), ''),
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
    final linkRegex = RegExp(r'\[(.+?)\]\((.+?)\)', dotAll: true);

    List<InlineSpan> spans = [];
    int cursor = 0;

    final linkMatches = linkRegex.allMatches(text).toList();

    for (final linkMatch in linkMatches) {
      int matchStart = linkMatch.start;
      int matchEnd = linkMatch.end;

      int markerLength = 0;
      for (var marker in ['**', '*', '`']) {
        if (matchStart >= marker.length &&
            text.substring(matchStart - marker.length, matchStart) == marker &&
            text.length >= matchEnd + marker.length &&
            text.substring(matchEnd, matchEnd + marker.length) == marker) {
          markerLength = marker.length;
          break;
        }
      }

      int gapEnd = matchStart - markerLength;
      if (gapEnd > cursor) {
        spans.addAll(_parseOtherStyles(text.substring(cursor, gapEnd)));
      }

      String linkLabel = linkMatch.group(1) ?? '';
      String url = linkMatch.group(2) ?? '';
      spans.add(
        TextSpan(
          text: linkLabel,
          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              }
            },
        ),
      );

      cursor = matchEnd + markerLength;
    }

    if (cursor < text.length) {
      spans.addAll(_parseOtherStyles(text.substring(cursor)));
    }

    return spans;
  }

  List<InlineSpan> _parseOtherStyles(String text) {
    final boldRegex = RegExp(r'\*\*(.+?)\*\*', dotAll: true);
    final italicRegex = RegExp(r'\*(.+?)\*', dotAll: true);
    final codeRegex = RegExp(r'`(.+?)`', dotAll: true);

    List<InlineSpan> spans = [];
    int cursor = 0;

    while (cursor < text.length) {
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
            const priorities = {'bold': 0, 'italic': 1, 'code': 2};
            if (priorities[t]! < priorities[type]!) {
              bestMatch = m;
              type = t;
            }
          }
        }
      }

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
      String content = bestMatch!.group(1) ?? '';

      final stripRegex = RegExp(r'\*\*|\*|`');
      String cleanedContent = content.replaceAll(stripRegex, '');

      if (type == 'bold') {
        spans.add(
          TextSpan(
            text: cleanedContent,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else if (type == 'italic') {
        spans.add(
          TextSpan(
            text: cleanedContent,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (type == 'code') {
        spans.add(
          TextSpan(
            text: cleanedContent,
            style: GoogleFonts.googleSansCode(
              textStyle: TextStyle(backgroundColor: Colors.grey.withValues(alpha: 0.2)),
            ),
          ),
        );
      }

      cursor = matchEnd;
    }

    return spans;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
