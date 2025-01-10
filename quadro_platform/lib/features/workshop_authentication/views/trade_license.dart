import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/views/widgets/document_upload_veiw.dart';
import 'package:quadro_platform/features/workshop_authentication/views/workshop_registeration_page.dart';

import 'package:quadro_platform/shared/enum/image_type.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

class TradeLicensePage extends StatelessWidget {
  final WorkshopAuthbloc licenscubit;

  const TradeLicensePage({super.key, required this.licenscubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: licenscubit, // Provide the passed cubit to the widget tree
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
            child: TradeLicenseVeiw(),
          ),
        ),
      ),
    );
  }
}

class TradeLicenseVeiw extends StatelessWidget {
  const TradeLicenseVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    final url = context.select<WorkshopAuthbloc, String?>(
      (cubit) => cubit.state.licensUrl,
    );

    return DocumentUploadView(
      title: "قم برفع وثيقة سجلك التجاري من أجل المتابعة:",
      assetPath: "assets/images/workshop/business-license-1.svg",
      buttonText: "تحميل الوثيقة",
      imageType: ImageType.tradeLicense,
      userId: "88",
      url: url,
      onContinue: (context) {
        NavigationService().routeTo(RoutesConstants.workshopdetails,
            arguments: context.read<WorkshopAuthbloc>());
      },
    );
  }
}
