import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

typedef CallbackNavigator = void Function();

class SectionHeader extends StatelessWidget {
  final String text;
  final bool? islarge;
  final bool? displayLarge;
  final bool? withButton;
  final CallbackNavigator? callback;

  const SectionHeader({
    required this.text,
    super.key,
    this.islarge,
    this.displayLarge,
    this.withButton,
    this.callback,
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
                Text(
                  text,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                InkWell(
                    onTap: callback,
                    child: Text("المزيد",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.apply(
                                decoration: TextDecoration.underline,
                                color: Qcolors.primarycolor)))
              ],
            )
          : Text(
              text,
              style: islarge != null
                  ? Theme.of(context).textTheme.headlineLarge
                  : displayLarge != null
                      ? Theme.of(context).textTheme.displayLarge
                      : Theme.of(context).textTheme.headlineMedium,
              softWrap: true,
            ),
    );
  }
}
