import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/request_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/maitenance_request_status.dart';
import '../../../../shared/routes/navigation_service.dart';
import '../../../../shared/routes/routes_constants.dart';
import '../../../../shared/widgets/requests_list.dart';
import '../../../../shared/widgets/vertical_spacing.dart';
import '../../bottomNavBars/main_bottom_navbar/user_main_nav_bar_screens.dart';
import '../bloc/main_screen_bloc.dart';
import 'widgets/gradient_card.dart';
import 'widgets/main_user_screen_header.dart';

class MainUserScreenView extends StatelessWidget {
  const MainUserScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainUserScreenBloc, MainUserScreenState>(
      listener: (context, state) {
        if (state.status == MainUserScreenStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? " error ",
                ),
              ),
            );
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VerticalSpacing(height: 50),
            const MainUserScreenHeader(),
            VerticalSpacing(height: 5.w),
            GradientCard(
              text: 'طلب خدمة سحب سيارة',
              imagePath: 'assets/images/icons/icons8-tow-truck-50.png',
              onTap: () {
                NavigationService().routeTo(RoutesConstants.bottomNavBar);
              },
            ),
            GradientCard(
              text: 'طلب خدمة صيانة سيارة',
              imagePath: 'assets/images/icons/icons8-car-50.png',
              onTap: () {
                NavigationService().routeTo(RoutesConstants.workshopSearch);
              },
            ),
            VerticalSpacing(height: 5.w),
            SectionHeader(
              requestType: RequestType.vehicle_owner_id,
              buttonColor: Qcolors.secondary,
              text: "الطلبات الحالية",
              withButton: true,
              callback: () => UserMainNavBarScreens().controller.jumpToTab(1),
            ),
            VerticalSpacing(height: 5.w),
            BlocBuilder<MainUserScreenBloc, MainUserScreenState>(
              builder: (context, state) {
                final list = state.requests;
                final status = state.requestStatus;

                return SharedRequestsList(
                  requestType: RequestType.vehicle_owner_id,
                  requests: list,
                  status: status,
                  noRequestsMessage: "لا يوجد طلبات حاليا",
                  errorMessage: "حدث خطاء في تحميل الطلبات",
                  buttonTitle: "تفاصيل الطلب",
                  buttonColor: Qcolors.secondary,
                  backgroundColor: Qcolors.getPrimeryColor(context),
                  onRequestDetails: (request, requestType) {
                    NavigationService().routeTo(
                      RoutesConstants.requestDetails,
                      arguments: {
                        'request': request,
                        'requestType': requestType,
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
