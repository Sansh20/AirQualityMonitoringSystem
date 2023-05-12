import 'package:flutter/material.dart';

class DetailComponent extends StatelessWidget {
  final double magnitude;
  final String title;
  final String sideText;

  final TextStyle magStyle;
  final TextStyle titleStyle;
  final TextStyle sideTextStyle;

  const DetailComponent({
    super.key,
    required this.magnitude,
    this.title = "",
    this.sideText = "",
    required this.magStyle,
    this.titleStyle = const TextStyle(),
    this.sideTextStyle = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              magnitude.toString(),
              style: magStyle,
            ),
            (sideText != "")
                ? Text(
                    sideText.padLeft(3),
                    style: sideTextStyle,
                  )
                : const SizedBox.shrink()
          ],
        ),
        (title != "")
            ? Text(
                title,
                style: titleStyle,
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
