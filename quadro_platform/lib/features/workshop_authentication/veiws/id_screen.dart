import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/trade_license.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/widgets/document_upload_veiw.dart';

import 'package:quadro_platform/shared/enum/image_type.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

class IdCardView extends StatelessWidget {
  const IdCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final url = context.select<WorkshopAuthbloc, String?>(
      (cubit) => cubit.state.idcardUrl,
    );

    return Scaffold(
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
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: DocumentUploadView(
            title: "قم برفع بطاقة هويتك من أجل المتابعة:",
            assetPath: "assets/images/workshop/id-card-svgrepo-com.svg",
            buttonText: "تحميل الهوية",
            imageType: ImageType.idCard,
            userId: "88",
            url: url,
            onContinue: (context) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TradeLicensePage(
                    licenscubit: context.read<WorkshopAuthbloc>(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
