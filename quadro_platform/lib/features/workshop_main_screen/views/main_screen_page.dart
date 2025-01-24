import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/bloc/main_screenbloc_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/features/workshop_main_screen/views/widgets/offers_list.dart';
import 'package:quadro_platform/features/workshop_main_screen/views/widgets/requests_list.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/widgets/request_templet.dart';
import 'package:quadro_platform/features/workshop_main_screen/views/widgets/workshop_name_widget.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:quadro_platform/shared/widgets/vertical_spacing.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/widgets/quadro_appbar.dart';
import '../../workshop_bottom_nav_bar/workshop_screens.dart';

class MainScreenPage extends StatelessWidget {
  const MainScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        notificationCallBack: () {},
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: BlocProvider(
          create: (context) => MainScreenBloc(
              context.read<WorkshopRepository>(),
              repositoryManager: context.read<RepositoryManager>())
            ..add(MainScreenStarted())
            ..add(MainScreenRequestFetched())
            ..add(MainScreenOffersFetched()),
          child: const MainScreenView(),
        ),
      ),
    );
  }
}

class MainScreenView extends StatelessWidget {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainScreenBloc, MainScreenState>(
      listener: (context, state) {
        if (state.status == MainScreenStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5.h,
            ),
            const WorkshopName(),
            const SectionHeader(
              requestType: RequestType.workshop_id,
              text: "مرحبا بعودتك ",
              displayLarge: true,
            ),
            const VerticalSpacing(height: 25),
            const SectionHeader(
              requestType: RequestType.workshop_id,
              text: "الطلبات الجديدة",
              islarge: true,
            ),
            SizedBox(
              height: 2.h,
            ),
            const RequestsList(),
            SectionHeader(
              requestType: RequestType.workshop_id,
              text: "  العروض الخاصة بي",
              callback: () {
                WorkshopScreens().controller.jumpToTab(2);
              },
              islarge: true,
              withButton: true,
            ),
            SizedBox(
              height: 2.h,
            ),
            const OffersList(),
            SizedBox(
              height: 8.h,
            ),
          ],
        ),
      ),
    );
  }
}
