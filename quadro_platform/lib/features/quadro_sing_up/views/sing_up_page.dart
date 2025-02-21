import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/quadro_sing_up/cubit/singup_cubit.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:sizer/sizer.dart';

import '../../../common/controller/services/toast_services.dart';
import '../../../constants/utils/colors.dart';
import '../../../shared/routes/navigation_service.dart';
import '../../../shared/routes/routes_constants.dart';

class SingUpPage extends StatelessWidget {
  const SingUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: SingUpView(),
    );
  }
}

class SingUpView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SingUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final signupCubit = context.read<SignupCubit>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'إنشاء حساب',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            NavigationService().replaceRoute(RoutesConstants.roleSelection);
          }
          if (state is SignupFailure) {
            ToastService.sendScaffoldAlert(
              msg: state.error,
              toastStatus: 'WARNING',
              context: context,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 8.h,
                    backgroundColor: white,
                    child: CircleAvatar(
                      radius: 8.h - 2,
                      backgroundColor: white,
                      backgroundImage: const AssetImage(
                          "assets/images/logos/quadroLogo.jpg"),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  Text(
                    "سجل الان",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(color: Qcolors.secondary),
                  ),
                  // البريد الإلكتروني
                  SizedBox(height: 5.h),

                  TextFormField(
                    controller: signupCubit.emailController,
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Qcolors.secondary,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال بريدك الإلكتروني';
                      }
                      // Simple regex for email validation
                      final emailRegExp = RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
                      if (!emailRegExp.hasMatch(value)) {
                        return 'يرجى إدخال بريد إلكتروني صالح';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5.h),

                  // كلمة المرور
                  TextFormField(
                    controller: signupCubit.passwordController,
                    decoration: const InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Qcolors.secondary,
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5.h),

                  // تأكيد كلمة المرور
                  TextFormField(
                    controller: signupCubit.confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Qcolors.secondary,
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != signupCubit.passwordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      if (state is SignupLoading) {
                        return const CircularProgressIndicator();
                      }
                      return CustomElevatedButton(
                        buttonColor: Qcolors.secondary,
                        buttonTitle: 'إنشاء حساب',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signupCubit.signUp();
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لديك حساب بالفعل؟  ",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      InkWell(
                        onTap: () =>
                            NavigationService().routeTo(RoutesConstants.login),
                        child: Text("تسجيل الدخول  ",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontSize: 16.sp, color: Qcolors.secondary)),
                      ),
                    ],
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
