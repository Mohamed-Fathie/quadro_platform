// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../features/workshop_bottom_nav_bar/workshop_screens.dart';
import '../../routes/navigation_service.dart';
import '../../utils/constans/colors.dart';
import '../custom_elevated_button.dart';

class OverlayMaintenanceRequest {
  factory OverlayMaintenanceRequest() => _shared;
  static final OverlayMaintenanceRequest _shared =
      OverlayMaintenanceRequest._sharedInstance();
  OverlayMaintenanceRequest._sharedInstance();

  late OverlayEntry overlay;

  void show({
    required BuildContext context,
    required String messageTitle,
    required String messageSubtitle,
  }) {
    showOverlay(
      context: context,
      messageTitle: messageTitle,
      messageSubtitle: messageSubtitle,
    );
  }

  void showOverlay({
    required BuildContext context,
    required String messageTitle,
    required String messageSubtitle,
  }) {
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
                  minHeight: size.height * 0.7),
              decoration: BoxDecoration(
                color: Qcolors.secondary,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20.h,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        messageTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        messageSubtitle,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      CustomElevatedButton(
                        buttonColor: Colors.white,
                        buttonTitle: "عودة للرئيسية",
                        onPressed: () {
                          overlay.remove();
                          NavigationService().goBack();
                          NavigationService().goBack();
                          WorkshopScreens().controller.jumpToTab(0);
                        },
                        icon: Icons.arrow_back,
                        iconColor: Qcolors.secondary,
                        // textColor: Qcolors.secondary,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);
  }
}
