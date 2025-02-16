import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/utils/colors.dart';
import '../../cubit/workshop_edit_cubit.dart';

class TextArea extends StatelessWidget {
  const TextArea({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WorkshopEditBloc>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        maxLines: 5,
        maxLength: 350,
        controller: bloc.descriptionController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'اكتب الوصف هنا',
          filled: true,
          fillColor: Colors.grey[200],
          // Hide the default counter
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
        onChanged: bloc.updateDescription,
      ),
    );
  }
}
