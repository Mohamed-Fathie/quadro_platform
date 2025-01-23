import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

typedef CallbackNavigator = void Function();

class SectionHeader extends StatelessWidget {
  final String text;
  final bool? islarge;
  final bool? displayLarge;
  final bool? withButton;
  final IconData? withIcon;
  final Color? textColor;
  final Color? buttonColor;
  final CallbackNavigator? callback;
  final RequestType requestType;

  const SectionHeader({
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
                    Text(text,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                                color: Qcolors.getColorForRequestType(
                                    requestType)))
                  ],
                )
              : Text(
                  text,
                  style: islarge != null
                      ? Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Qcolors.getColorForRequestType(requestType))
                      : displayLarge != null
                          ? Theme.of(context).textTheme.displayLarge
                          : Theme.of(context).textTheme.headlineMedium,
                  softWrap: true,
                ),
    );
  }
}
