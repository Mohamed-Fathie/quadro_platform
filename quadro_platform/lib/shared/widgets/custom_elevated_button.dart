import 'package:flutter/material.dart';

typedef CallbackAction = void Function();

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {required this.buttonTitle,
      super.key,
      this.icon,
      this.iconColor,
      required this.buttonColor,
      required this.onPressed});
  final String buttonTitle;
  final CallbackAction onPressed;
  final Color buttonColor;
  final IconData? icon;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(200, 57),
            backgroundColor: buttonColor),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(buttonTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .apply(color: iconColor ?? Colors.white)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: iconColor ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
