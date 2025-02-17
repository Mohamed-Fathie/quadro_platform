import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/quadro_sing_up/cubit/tow_owner_cubit.dart';
import 'package:sizer/sizer.dart';

import '../../../common/controller/services/toast_services.dart';
import '../../../common/view/logInLogic/login_bloc/bloc/login_bloc.dart';
import '../../../shared/routes/navigation_service.dart';
import '../../../shared/routes/routes_constants.dart';
import '../../../shared/utils/constans/colors.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/gradient_circular_progress.dart';
import '../../workshop_authentication/repository/storage_repository.dart';
import '../../workshop_main_screen/repository/repository_manager.dart';
import '../cubit/tow_owner_state.dart';
import 'widgets/image_picker_tow.dart';

class TowOwnerPage extends StatelessWidget {
  const TowOwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TowServiceProviderCubit(
          context.read<RepositoryManager>().userRepository,
          FirebaseAuth.instance,
          StorageRepository()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TowServiceProviderForm(),
      ),
    );
  }
}

class TowServiceProviderForm extends StatelessWidget {
  TowServiceProviderForm({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TowServiceProviderCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إنشاء حساب',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: BlocListener<TowServiceProviderCubit, TowServiceProviderState>(
        listener: (context, state) {
          if (state.status == TowServiceProviderStatus.success) {
            ToastService.sendScaffoldAlert(
              msg: "تم التسجيل بنجاح",
              toastStatus: 'SUCCESS',
              context: context,
            );
            context.read<LoginBloc>().add(AppInitialization());
            NavigationService().clearAndNavigateTo(RoutesConstants.flow);
          }
          if (state.status == TowServiceProviderStatus.error &&
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
                  // Image picker widget.
                  const TowPickTowImageWidget(),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: cubit.nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Qcolors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الكامل';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  TextFormField(
                    controller: cubit.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الجوال',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Qcolors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الجوال';
                      }
                      if (value.length != 10) {
                        return 'رقم الجوال غير صحيح';
                      }
                      return null;
                    },
                  ),
                  // === Tow Service Provider Specific Fields ===
                  SizedBox(height: 3.h),
                  TextFormField(
                    controller: cubit.towCompanyController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'نوع شركة الساحبة',
                      hintText: "",
                      prefixIcon: Icon(
                        Icons.business,
                        color: Qcolors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال نوع شركة الساحبة';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  TextFormField(
                    controller: cubit.towModelController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'موديل الساحبة',
                      hintText: "",
                      prefixIcon: Icon(
                        Icons.directions_car,
                        color: Qcolors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال موديل الساحبة';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  // Label for the vehicle type dropdown.
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'نوع الساحبة',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  DropdownButtonFormField<String>(
                    value: cubit.state.selectedVehicleType,
                    items: cubit.vehicleTypes
                        .map((String type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      cubit.setSelectedVehicleType(newValue);
                    },
                    decoration: const InputDecoration(
                      hintText: "اختر نوع مركبتك",
                      prefixIcon: Icon(
                        Icons.category,
                        color: Qcolors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value == 'اختر نوع مركبتك') {
                        return 'الرجاء اختيار نوع المركبة';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  TextFormField(
                    controller: cubit.towChassisController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'رقم هيكل الساحبة',
                      hintText: "",
                      prefixIcon: Icon(
                        Icons.confirmation_number,
                        color: Qcolors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم هيكل الساحبة';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  TextFormField(
                    controller: cubit.licenseController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'رقم رخصة القيادة',
                      hintText: "",
                      prefixIcon: Icon(
                        Icons.card_membership,
                        color: Qcolors.secondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم رخصة القيادة';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),
                  // === Submit Button ===
                  BlocBuilder<TowServiceProviderCubit, TowServiceProviderState>(
                    builder: (context, state) {
                      if (state.status == TowServiceProviderStatus.loading) {
                        return const Center(child: GradientCircularProgress());
                      }
                      return CustomElevatedButton(
                        buttonColor: Qcolors.primarycolor,
                        buttonTitle: 'تأكيد المعلومات',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final image = cubit.state.imageFile;
                            cubit.submitTowServiceProviderInfo(
                              image: image,
                              name: cubit.nameController.text,
                              phone: cubit.phoneController.text,
                              towCompany: cubit.towCompanyController.text,
                              towModel: cubit.towModelController.text,
                              vehicleType: cubit.state.selectedVehicleType,
                              towChassis: cubit.towChassisController.text,
                              license: cubit.licenseController.text,
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
