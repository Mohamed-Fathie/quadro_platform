import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/workshop_edit_cubit.dart';

class WorkshopPhone extends StatelessWidget {
  const WorkshopPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: context.read<WorkshopEditBloc>().phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'رقم الهاتف',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: context.read<WorkshopEditBloc>().updatePhone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال رقم الهاتف';
            }
            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
              return 'رقم الهاتف يجب أن يكون 10 أرقام';
            }
            return null;
          },
        ),
      ),
    );
  }
}
