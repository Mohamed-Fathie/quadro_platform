import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/authbloc_cubit.dart';

class WorkshopName extends StatelessWidget {
  const WorkshopName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: context.read<WorkshopAuthbloc>().nameController,
          decoration: InputDecoration(
            labelText: 'اسم الورشة',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: context.read<WorkshopAuthbloc>().updateName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال اسم الورشة';
            }
            return null;
          },
        ),
      ),
    );
  }
}
