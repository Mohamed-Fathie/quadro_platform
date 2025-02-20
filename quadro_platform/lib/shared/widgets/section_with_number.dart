import 'package:flutter/material.dart';

import '../enum/maitenance_request_status.dart';
import '../utils/constans/colors.dart';

typedef CallbackNavigator = void Function();

class SectionWithNumber extends StatelessWidget {
  final String text;
  final bool? islarge;
  final bool? displayLarge;
  final bool? withButton;
  final IconData? withIcon;
  final Color? textColor;
  final Color? buttonColor;
  final CallbackNavigator? callback;
  final RequestType requestType;
  final Color? numberColor; // New property for number color

  const SectionWithNumber({
    required this.text,
    super.key,
    this.islarge,
    this.displayLarge,
    this.withButton,
    this.callback,
    this.withIcon,
    required this.requestType,
    this.textColor,
    this.buttonColor,
    this.numberColor, // Initialize number color
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: withButton != null
          ? Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStyledText(context), // Use RichText version
                InkWell(
                    onTap: callback,
                    child: Text("المزيد",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.apply(
                                decoration: TextDecoration.underline,
                                color: buttonColor ?? Qcolors.primarycolor)))
              ],
            )
          : withIcon != null
              ? Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      size: 40,
                      withIcon,
                      color: Qcolors.getColorForRequestType(requestType),
                    ),
                    _buildStyledText(context) // Use RichText version
                  ],
                )
              : _buildStyledText(context), // Default case uses RichText
    );
  }

  /// Helper function to build styled text with colored number
  Widget _buildStyledText(BuildContext context) {
    final textStyle = islarge != null
        ? Theme.of(context).textTheme.headlineLarge?.copyWith(color: textColor)
        : displayLarge != null
            ? Theme.of(context).textTheme.displayLarge
            : Theme.of(context).textTheme.headlineMedium;

    // Regular expression to detect numbers in the text
    final RegExp numberRegex = RegExp(r'(\d+)');
    final List<TextSpan> spans = [];

    text.splitMapJoin(numberRegex, onMatch: (match) {
      spans.add(
        TextSpan(
          text: match.group(0),
          style: textStyle?.copyWith(
            color: numberColor ?? Colors.red, // Color for numbers
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return '';
    }, onNonMatch: (nonMatch) {
      spans.add(
        TextSpan(
          text: nonMatch,
          style: textStyle,
        ),
      );
      return '';
    });

    return RichText(
      text: TextSpan(children: spans),
      textDirection: TextDirection.rtl,
    );
  }
}
