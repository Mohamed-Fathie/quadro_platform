import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/shared/utils/serivces/image_picker_service.dart';
import 'package:quadro_platform/shared/enum/image_type.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/gradient_circular_progress.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkshopAuthbloc, WorkshopAuthblocState>(
      listener: (context, state) {
        if (state.exception != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("فشل تحميل الصورة"),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.status == WorkshopAuthStatus.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GradientCircularProgress(),
                const SizedBox(height: 10),
                Text('${state.progress?.toStringAsFixed(2)}% تم تحميل'),
              ],
            ),
          );
        }

        return SizedBox(
            width: 130,
            height: 130,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              // Inside PickImageWidget's build method
              backgroundImage: state.imageProfile != null
                  ? FileImage(File(state.imageProfile!.path))
                  : (state.profilImageUrl != null &&
                          state.profilImageUrl!.isNotEmpty
                      ? NetworkImage(state.profilImageUrl!)
                      : const AssetImage(
                          "assets/images/uberLogo/quadroLogo.png")),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: GestureDetector(
                            onTap: () async => await DefaultImagePickerService()
                                .pickImage()
                                // ignore: use_build_context_synchronously
                                .then((value) => context
                                    .read<WorkshopAuthbloc>()
                                    .uploadImage(
                                      file: value,
                                      imageType: ImageType.profile,
                                    )),
                            child: const Icon(
                              Icons.camera_alt_sharp,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Your GestureDetector logic here
                ],
              ),
            ));
      },
    );
  }
}
