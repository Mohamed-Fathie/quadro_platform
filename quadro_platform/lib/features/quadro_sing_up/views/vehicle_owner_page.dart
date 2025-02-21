import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/storage_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:quadro_platform/shared/widgets/gradient_circular_progress.dart';
import 'package:sizer/sizer.dart';

import '../../../common/controller/services/toast_services.dart';
import '../../../common/view/logInLogic/login_bloc/bloc/login_bloc.dart';
import '../../../constants/utils/colors.dart';
import '../cubit/vehicle_owner_cubit.dart';
import '../cubit/vehicle_owner_state.dart';
import 'widgets/image_pickker.dart';

class VehicleOwnerScreen extends StatelessWidget {
  const VehicleOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleOwnerCubit(
          context.read<RepositoryManager>().userRepository,
          FirebaseAuth.instance,
          StorageRepository()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: VehicleOwnerForm(),
      ),
    );
  }
}

class VehicleOwnerForm extends StatelessWidget {
  VehicleOwnerForm({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VehicleOwnerCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إنشاء حساب',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: BlocListener<VehicleOwnerCubit, VehicleOwnerState>(
        listener: (context, state) {
          if (state.status == VehicleOwnerStatus.success) {
            ToastService.sendScaffoldAlert(
              msg: "تم التسجيل بنجاح",
              toastStatus: 'SUCCESS',
              context: context,
            );
            context.read<LoginBloc>().add(AppInitialization());
            NavigationService().clearAndNavigateTo(RoutesConstants.flow);
          }
          if (state.status == VehicleOwnerStatus.error &&
              state.exception != null) {
            ToastService.sendScaffoldAlert(
              msg: state.exception!,
              toastStatus: 'WARNING',
              context: context,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Use the new image picker widget.
                  const PickImageWidget(),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: cubit.nameController,
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: teal,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الكامل';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h), //0910097738

                  TextFormField(
                    controller: cubit.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: teal,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف';
                      }
                      if (value.length != 10) {
                        return 'رقم الهاتف غير صحيح';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),
                  BlocBuilder<VehicleOwnerCubit, VehicleOwnerState>(
                    builder: (context, state) {
                      if (state.status == VehicleOwnerStatus.loading) {
                        return const Center(child: GradientCircularProgress());
                      }
                      return CustomElevatedButton(
                        buttonColor: Qcolors.primarycolor,
                        buttonTitle: 'تأكيد المعلومات',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final image = context
                                .read<VehicleOwnerCubit>()
                                .state
                                .imageFile;
                            context
                                .read<VehicleOwnerCubit>()
                                .submitVehicleOwnerInfo(
                                  image: image,
                                  name: cubit.nameController.text,
                                  phone: cubit.phoneController.text,
                                );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
