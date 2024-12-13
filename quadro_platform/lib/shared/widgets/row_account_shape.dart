import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/circler_image.dart';
import 'package:sizer/sizer.dart';

class RowHeader extends StatelessWidget {
  const RowHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              softWrap: true,
              " mohamed fathi jdour abdallh",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .apply(color: Qcolors.primarycolor),
            ),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
                child: CirclerImage(
                    editting: () {},
                    imagePath: "assets/images/uberLogo/quadroLogo.png")),
          )
        ],
      ),
    );
  }
}
