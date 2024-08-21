import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/text_style_utils.dart';

class ClickableText extends StatelessWidget {
  final String text;

  ClickableText({required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style:  TextStyles.light(fontSize: 18),
        children: _linkify(text),
      ),
    );
  }

  List<TextSpan> _linkify(String text) {
    final RegExp urlRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    List<TextSpan> spans = [];
    int start = 0;

    for (RegExpMatch match in urlRegExp.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      final String url = match.group(0)!;

      spans.add(
        TextSpan(
          text: url,
          style:  TextStyles.light(fontSize: 18, color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}