import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/shared/utils/constans/helper_functions.dart';

class TextArea extends StatelessWidget {
  const TextArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkshopAuthbloc>();
    final textdescription =
        context.select((WorkshopAuthbloc cubit) => cubit.state.description);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        maxLines: 5,
        maxLength: 350,
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
        onChanged: cubit.updateText,
        controller: cubit.textareaController
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: textdescription!.length),
          ),
      ),
    );
  }
}
