import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/common/controller/services/auth_services.dart';

part 'singup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  // Controllers are now properties of the Cubit.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> signUp() async {
    // Extract values from controllers.
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validate email.
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    if (email.isEmpty) {
      emit(SignupFailure('يرجى إدخال بريدك الإلكتروني'));
      return;
    }
    if (!emailRegExp.hasMatch(email)) {
      emit(SignupFailure('يرجى إدخال بريد إلكتروني صالح'));
      return;
    }

    // Validate password.
    if (password.isEmpty) {
      emit(SignupFailure('يرجى إدخال كلمة المرور'));
      return;
    }
    if (password.length < 8) {
      emit(SignupFailure('يجب أن تتكون كلمة المرور من 6 أحرف على الأقل'));
      return;
    }

    // Validate password confirmation.
    if (password != confirmPassword) {
      emit(SignupFailure('كلمتا المرور غير متطابقتين'));
      return;
    }

    // If all validations pass, proceed with the sign-up process.
    emit(SignupLoading());

    // Add your actual sign-up logic here.
    // For demonstration, we assume success if all fields are non-empty.
    if (email.isNotEmpty && password.isNotEmpty) {
      String? exception =
          await AuthServices.signUp(email: email, password: password);
      if (exception != null) {
        emit(SignupFailure(exception));
        return;
      }
      emit(SignupSuccess());
    } else {
      emit(SignupFailure('فشل التسجيل. يرجى التحقق من معلوماتك.'));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
