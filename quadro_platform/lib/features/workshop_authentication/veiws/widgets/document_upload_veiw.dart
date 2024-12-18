import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/models/image_picker_service.dart';
import 'package:quadro_platform/shared/enum/image_type.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/utils/constans/helper_functions.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:sizer/sizer.dart';

class DocumentUploadView extends StatelessWidget {
  final String title;
  final String assetPath;
  final String buttonText;
  final ImageType imageType;
  final String userId;
  final String? url;
  final Function(BuildContext) onContinue;

  const DocumentUploadView({
    super.key,
    required this.title,
    required this.assetPath,
    required this.buttonText,
    required this.imageType,
    required this.userId,
    required this.url,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = QhelperFucntions().isDarkMode(context);
    final cubitt = context.read<WorkshopAuthbloc>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 50),
              Text(
                textAlign: TextAlign.center,
                title,
                style: Theme.of(context).textTheme.headlineLarge?.apply(
                      color: isDark ? Colors.white : Qcolors.blackFont,
                    ),
              ),
              const SizedBox(height: 50),
              SvgPicture.asset(
                width: 70.w,
                height: 30.h,
                assetPath,
              ),
              const SizedBox(height: 50),
              BlocBuilder<WorkshopAuthbloc, WorkshopAuthblocState>(
                builder: (context, state) {
                  if (state.status == WorkshopAuthStatus.loading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: state.progress != null
                                ? state.progress! / 100
                                : null,
                            color: Qcolors.primarycolor,
                            strokeWidth: 8.0,
                          ),
                          const SizedBox(height: 10),
                          Text(
                              'تم تحميل ${state.progress?.toStringAsFixed(2)} %'),
                        ],
                      ),
                    );
                  }
                  if (url != null) {
                    return const Text(
                        textAlign: TextAlign.center, " تم تحميل الوثيقة بنجاح");
                  }
                  return CustomElevatedButton(
                    iconColor: Qcolors.primarycolor,
                    buttonTitle: buttonText,
                    icon: Icons.image_search_outlined,
                    buttonColor: const Color.fromARGB(255, 216, 239, 244),
                    onPressed: () async => await DefaultImagePickerService()
                        .pickImage()
                        .then((value) => cubitt.uploadImage(
                              file: value,
                              imageType: imageType,
                              userId: userId,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: url == null
              ? const SizedBox()
              : CustomElevatedButton(
                  buttonTitle: "متابعة",
                  buttonColor: Qcolors.primarycolor,
                  onPressed: () => onContinue(context),
                  icon: Icons.arrow_forward,
                ),
        ),
      ],
    );
  }
}
