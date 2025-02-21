import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/serivces/image_picker_service.dart';
import '../../../../shared/widgets/gradient_circular_progress.dart';
import '../../cubit/tow_owner_cubit.dart';
import '../../cubit/tow_owner_state.dart';

class TowPickTowImageWidget extends StatelessWidget {
  const TowPickTowImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TowServiceProviderCubit, TowServiceProviderState>(
      listener: (context, state) {
        if (state.exception != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.exception!)),
            );
        }
      },
      builder: (context, state) {
        if (state.status == TowServiceProviderStatus.loading) {
          return const Center(child: GradientCircularProgress());
        }

        return SizedBox(
          width: 130,
          height: 130,
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _getImageSource(state),
            child: Stack(
              children: [
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: _buildCameraButton(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ImageProvider _getImageSource(TowServiceProviderState state) {
    if (state.imageFile != null) {
      return FileImage(state.imageFile!);
    }
    if (state.imageUrl?.isNotEmpty == true) {
      return NetworkImage(state.imageUrl!);
    }
    return const AssetImage("assets/images/uberLogo/quadroLogo.png");
  }

  Widget _buildCameraButton(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: GestureDetector(
        onTap: () async {
          // Use your image picker service here.
          final image = await DefaultImagePickerService().pickImage();
          if (image != null) {
            context
                .read<TowServiceProviderCubit>()
                .updateProfileImage(File(image.path));
          }
        },
        child: const Icon(
          Icons.camera_alt_sharp,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
