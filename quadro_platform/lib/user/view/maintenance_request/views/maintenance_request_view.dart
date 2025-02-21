// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/car_models.dart';
import '../../../../shared/enum/maitenance_request_status.dart';
import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/utils/serivces/image_picker_service.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../shared/widgets/overlay_dialog/secondary_overlay.dart';
import '../../../../shared/widgets/section_header.dart';
import '../cubit/maintenacne_request_cubit.dart'; // for 5.h and 3.h (if you use it)

class MaintenanceRequestForm extends StatelessWidget {
  final Workshop workshop;
  MaintenanceRequestForm({super.key, required this.workshop});

  // Create a GlobalKey for the Form widget.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MaintenanceRequestCubit>();

    return BlocListener<MaintenanceRequestCubit, MaintenanceRequestState>(
      listener: (context, state) {
        if (state.status == MaintenanceRequestCubitStatues.success) {
          OverlayMaintenanceRequest().show(
            context: context,
            messageTitle: " ! تم إرسال طلبك بنجاح",
            messageSubtitle:
                "سيتم مراجعة الطلب من قبل الورشة\nوإعلامك بالعرض قريباً",
          );
        }
        if (state.status == MaintenanceRequestCubitStatues.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 5.h),
              const SectionHeader(
                text: "ادخل تفاصيل المركبة",
                requestType: RequestType.vehicle_owner_id,
              ),
              SizedBox(height: 3.h),
              // Car Brand & Car Model Dropdown Row
              BlocBuilder<MaintenanceRequestCubit, MaintenanceRequestState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<CarBrand>(
                          value: state.selectedCarBrand,
                          items: CarBrand.values.map((brand) {
                            return DropdownMenuItem(
                              value: brand,
                              child: Text(brand.toArabic()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) cubit.selectCarBrand(value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "يرجى اختيار نوع الشركة";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "نوع الشركة",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Qcolors.secondary),
                          ),
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<CarModels>(
                          // Ensure the value is only set if it's in the current models list.
                          value: state.selectedCarBrand?.models
                                      .contains(state.selectedCarModel) ==
                                  true
                              ? state.selectedCarModel
                              : null,
                          items: state.selectedCarBrand?.models
                              .map((model) => DropdownMenuItem(
                                    value: model,
                                    child: Text(model.toArabic()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) cubit.selectCarModel(value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "يرجى اختيار موديل السيارة";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "موديل السيارة",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Qcolors.secondary),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 5.h),
              const SectionHeader(
                text: "ادخل وصف مشكلة المركبة(نص وصورة مرفقة)",
                requestType: RequestType.vehicle_owner_id,
              ),
              SizedBox(height: 3.h),
              // Description Text Field
              BlocBuilder<MaintenanceRequestCubit, MaintenanceRequestState>(
                builder: (context, state) {
                  return TextFormField(
                    maxLines: 5,
                    maxLength: 350,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'اكتب الوصف هنا',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: cubit.updateDescription,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "يرجى ادخال وصف المشكلة";
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 3.h),
              // Image Upload Section
              BlocBuilder<MaintenanceRequestCubit, MaintenanceRequestState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state.image != null)
                        Image.file(
                          state.image!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      state.image == null
                          ? CustomElevatedButton(
                              buttonColor: Qcolors.secondary,
                              buttonTitle: "تحميل صورة المركبة",
                              onPressed: () async {
                                await DefaultImagePickerService()
                                    .pickImage()
                                    .then((value) {
                                  if (value == null) {
                                    return;
                                  } else {
                                    context
                                        .read<MaintenanceRequestCubit>()
                                        .updateImage(File(value.path));
                                  }
                                });
                              },
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              // Submit Button
              // Submit Button
              BlocBuilder<MaintenanceRequestCubit, MaintenanceRequestState>(
                builder: (context, state) {
                  return state.status ==
                          MaintenanceRequestCubitStatues.submitting
                      ? const Center(child: CircularProgressIndicator())
                      : CustomElevatedButton(
                          buttonColor: Qcolors.secondary,
                          buttonTitle: "ارسال الطلب",
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => Directionality(
                                  textDirection:
                                      TextDirection.rtl, // Force RTL for Arabic
                                  child: AlertDialog(
                                    icon: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Qcolors.warning,
                                        size: 40),
                                    iconColor: Qcolors.warning.withOpacity(0.2),
                                    backgroundColor:
                                        Theme.of(context).dialogBackgroundColor,
                                    surfaceTintColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    title: Row(
                                      children: [
                                        Text(
                                          "تأكيد الإرسال",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Qcolors.secondary,
                                              ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.help_outline_rounded,
                                            color: Qcolors.secondary, size: 24),
                                      ],
                                    ),
                                    content: Text(
                                      "هل أنت متأكد من رغبتك في إرسال طلب الصيانة إلى الورشة؟",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[200],
                                                foregroundColor:
                                                    Colors.grey[800],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("إلغاء"),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Qcolors.secondary,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child:
                                                  const Text("تأكيد الإرسال"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              if (confirmed == true) {
                                cubit.submitRequest(workshop);
                              }
                            }
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
