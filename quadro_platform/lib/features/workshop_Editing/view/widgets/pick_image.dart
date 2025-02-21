import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/utils/serivces/image_picker_service.dart';
import '../../cubit/workshop_edit_cubit.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkshopEditBloc, WorkshopEditState>(
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
        if (state.status == WorkshopEditStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Qcolors.primarycolor,
              strokeWidth: 8.0,
            ),
          );
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

  ImageProvider _getImageSource(WorkshopEditState state) {
    if (state.imageFile != null) {
      return FileImage(File(state.imageFile!.path));
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
          final image = await DefaultImagePickerService().pickImage();
          if (image != null) {
            context.read<WorkshopEditBloc>().updateProfileImage(image);
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
