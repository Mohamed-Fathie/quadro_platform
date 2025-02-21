import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_Editing/cubit/workshop_edit_cubit.dart';
import 'package:quadro_platform/features/workshop_Editing/view/widgets/workshop_phone.dart';
import 'package:quadro_platform/shared/widgets/gradient_circular_progress.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/enum/maitenance_request_status.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/vertical_spacing.dart';
import 'widgets/brand_list.dart';
import 'widgets/dropdown_menu.dart';
import 'widgets/location_button.dart';
import 'widgets/pick_image.dart';
import 'widgets/save_button.dart';
import 'widgets/spare_parts.dart';
import 'widgets/text_area.dart';
import 'widgets/workshop_name.dart';

class WorkshopEditView extends StatelessWidget {
  const WorkshopEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkshopEditBloc, WorkshopEditState>(
      listener: (context, state) {
        if (state.status == WorkshopEditStatus.failure) {
          debugPrint('Error: ${state.exception}');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.exception ?? 'حدث خطأ أثناء التعديل'),
              ),
            );
        }
        if (state.status == WorkshopEditStatus.saved) {
          Navigator.of(context).pop(true); // Navigate back after update
        }
      },
      child: SingleChildScrollView(
        child: BlocSelector<WorkshopEditBloc, WorkshopEditState,
            WorkshopEditStatus>(
          selector: (state) {
            return state.status;
          },
          builder: (context, state) {
            if (state == WorkshopEditStatus.initial) {
              return SizedBox(
                  height: 50.h,
                  child: const Center(child: GradientCircularProgress()));
            }
            return Column(
              // Reuse the same UI components as WorkshopRegisterationView
              children: [
                const PickImageWidget(),
                const VerticalSpacing(height: 30),
                Text(
                  "تعديل معلومات حساب الورشة",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const VerticalSpacing(height: 40),
                const SectionHeader(
                  requestType: RequestType.workshop_id,
                  text: "تعديل اسم الورشة",
                ),
                const VerticalSpacing(height: 20),
                const WorkshopName(),
                const VerticalSpacing(height: 20),
                const SectionHeader(
                  requestType: RequestType.workshop_id,
                  text: "تعديل رقم الورشة",
                ),
                const VerticalSpacing(height: 20),
                const WorkshopPhone(),
                const VerticalSpacing(height: 20),
                const SectionHeader(
                  requestType: RequestType.workshop_id,
                  text: "تعديل وصف الورشة",
                ),
                const VerticalSpacing(height: 25),
                const TextArea(),
                const VerticalSpacing(height: 25),
                const SectionHeader(
                  requestType: RequestType.workshop_id,
                  text: "تعديل أنواع شركات السيارات",
                ),
                const VerticalSpacing(height: 25),
                const DropdownMinu(),
                const VerticalSpacing(height: 25),
                const BrandList(),
                const VerticalSpacing(height: 25),
                const SectionHeader(
                  requestType: RequestType.workshop_id,
                  text: "تعديل حالة القطع",
                ),
                const VerticalSpacing(height: 20),
                const SpareParts(),
                const VerticalSpacing(height: 25),
                const SectionHeader(
                  requestType: RequestType.workshop_id,
                  text: "تعديل موقع الورشة",
                ),
                const VerticalSpacing(height: 20),
                const LocationButton(),
                const VerticalSpacing(height: 20),
                const SaveButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}
