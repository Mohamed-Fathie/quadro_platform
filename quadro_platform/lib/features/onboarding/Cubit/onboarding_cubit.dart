import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0); // Initial page index is 0.
  final pagecontroller = PageController();
  void updatePage(int index) => emit(index);
  void nextPage() {
    pagecontroller.jumpToPage(state + 1);
  }

  @override
  Future<void> close() {
    pagecontroller.dispose();
    return super.close();
  }
}
