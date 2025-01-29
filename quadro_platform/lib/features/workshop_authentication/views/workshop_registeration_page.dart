import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/google_map/model/selected_location.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/views/widgets/brand_list.dart';
import 'package:quadro_platform/features/workshop_authentication/views/widgets/dropdown_minu.dart';
import 'package:quadro_platform/features/workshop_authentication/views/widgets/pick_image.dart';
import 'package:quadro_platform/features/workshop_authentication/views/widgets/save_button.dart';
import 'package:quadro_platform/features/workshop_authentication/views/widgets/spare_parts.dart';
import 'package:quadro_platform/features/workshop_authentication/views/widgets/text_area.dart';
import 'package:quadro_platform/features/workshop_authentication/views/workshop_authenitication_page.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:quadro_platform/shared/widgets/vertical_spacing.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/enum/maitenance_request_status.dart';
import 'widgets/location_button.dart';

class WorkshopDetainsPage extends StatelessWidget {
  final WorkshopAuthbloc detailscubit;

  const WorkshopDetainsPage({super.key, required this.detailscubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: detailscubit, // Provide the passed cubit to the widget tree
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "اعداد الحساب",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .apply(color: Qcolors.primarycolor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(5.w, 0.1.h, 5.w, 0.5.h),
          child: const Directionality(
            textDirection: TextDirection.rtl,
            child: WorkshopRegisterationView(),
          ),
        ),
      ),
    );
  }
}

class WorkshopRegisterationView extends StatelessWidget {
  const WorkshopRegisterationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkshopAuthbloc, WorkshopAuthblocState>(
      listener: (context, state) {
        if (state.status == WorkshopAuthStatus.failure) {
          debugPrint('Error: ${state.exception}');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.exception ?? 'حدث خطأ أثناء المصادقة'),
              ),
            );
        }
        if (state.status == WorkshopAuthStatus.workshopAuthenticated) {
          NavigationService()
              .clearAndNavigateTo(RoutesConstants.workshopBottomNavBar);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            const PickImageWidget(),
            const VerticalSpacing(height: 30),
            Text(
              " قم باعداد حساب عملك",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const VerticalSpacing(height: 40),
            const SectionHeader(
                requestType: RequestType.workshop_id, text: "اضف وصف للورشة"),
            const VerticalSpacing(height: 25),
            const TextArea(),
            const VerticalSpacing(height: 25),
            const SectionHeader(
                requestType: RequestType.workshop_id,
                text: "انواع شركات السيارات التي تعمل بها"),
            const VerticalSpacing(height: 25),
            const DropdownMinu(),
            const VerticalSpacing(height: 25),
            const BrandList(),
            const VerticalSpacing(height: 25),
            const SectionHeader(
                requestType: RequestType.workshop_id,
                text: "حالة القطع التي تعمل بها"),
            const VerticalSpacing(height: 20),
            const SpareParts(),
            const VerticalSpacing(height: 25),
            const SectionHeader(
                requestType: RequestType.workshop_id, text: "موقع الورشة"),
            const VerticalSpacing(height: 20),
            const LocationButton(),
            const VerticalSpacing(height: 20),
            const SaveButton()
          ],
        ),
      ),
    );
  }
}
