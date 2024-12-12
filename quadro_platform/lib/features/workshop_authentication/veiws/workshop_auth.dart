import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quadro_platform/shared/utils/constans/helper_functions.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';

typedef CallbackAction = void Function();

class WorkshopAuth extends StatelessWidget {
  const WorkshopAuth(
      {super.key,
      required this.imagecallback,
      required this.describtion,
      required this.assetpath,
      required this.icontext});
  final CallbackAction imagecallback;
  final String describtion;
  final String assetpath;
  final String icontext;

  @override
  Widget build(BuildContext context) {
    final bool isDark = QhelperFucntions().isDarkMode(context);
    final double width = QhelperFucntions().screennWidth(context);
    final double height = QhelperFucntions().screennheight(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "توثيق الحساب",
          style: Theme.of(context).textTheme.headlineMedium?.apply(
                color: Qcolors.primarycolor,
              ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    describtion,
                    style: Theme.of(context).textTheme.headlineLarge?.apply(
                          color: isDark ? Colors.white : Qcolors.blackFont,
                        ),
                  ),
                  const SizedBox(height: 50),
                  SvgPicture.asset(
                    width: width * 0.7,
                    height: height * 0.3,
                    assetpath,
                  ),
                  const SizedBox(height: 50),
                  CustomElevatedButton(
                    iconColor: Qcolors.primarycolor,
                    buttonTitle: icontext,
                    icon: Icons.image_search_outlined,
                    buttonColor: const Color.fromARGB(255, 216, 239, 244),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomElevatedButton(
                buttonTitle: "متابعة",
                buttonColor: Qcolors.primarycolor,
                onPressed: () {},
                icon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
