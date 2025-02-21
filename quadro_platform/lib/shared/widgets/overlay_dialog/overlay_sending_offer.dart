import 'package:flutter/material.dart';
import 'package:quadro_platform/features/workshop_bottom_nav_bar/workshop_nav_bar.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:sizer/sizer.dart';

import '../../../features/workshop_bottom_nav_bar/workshop_screens.dart';
import '../../routes/navigation_service.dart';
import '../../routes/routes_constants.dart';
import '../../utils/constans/helper_functions.dart';

class OverlaySendingOffer {
  factory OverlaySendingOffer() => _shared;
  static final OverlaySendingOffer _shared =
      OverlaySendingOffer._sharedInstance();
  OverlaySendingOffer._sharedInstance();

  late OverlayEntry overlay;
  void show({
    required BuildContext context,
  }) {
    showOverlay(
      context: context,
    );
  }

  void showOverlay({required BuildContext context}) {
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                  maxHeight: size.height * 0.8,
                  minWidth: size.width * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Qcolors.primarycolor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Icon(
                          Icons.car_repair,
                          color: const Color(0xFFE4F4F7),
                          size: 30.h,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "! تم تقديم عرضك بنجاح",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "بانتظار موافقة العميل عليه",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomElevatedButton(
                          buttonColor: const Color(0xFFE4F4F7),
                          buttonTitle: "عودة للرئيسية",
                          onPressed: () {
                            overlay.remove();
                            NavigationService().goBack();
                            NavigationService().goBack();
                            WorkshopScreens().controller.jumpToTab(0);
                          },
                          icon: Icons.arrow_back,
                          iconColor: Qcolors.primarycolor,
                        )
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );

    state.insert(overlay);
  }
}
