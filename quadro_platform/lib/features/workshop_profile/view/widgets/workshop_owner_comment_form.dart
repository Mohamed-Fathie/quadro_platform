import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../cubit/workshop_profile_cubit.dart';

class WorkshopOwnerCommentForm extends StatefulWidget {
  final String reviewId;

  const WorkshopOwnerCommentForm({super.key, required this.reviewId});

  @override
  State<WorkshopOwnerCommentForm> createState() =>
      _WorkshopOwnerCommentFormState();
}

class _WorkshopOwnerCommentFormState extends State<WorkshopOwnerCommentForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // Initialize controller
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkshopProfileCubit>();

    return BlocSelector<WorkshopProfileCubit, WorkshopProfileState, String?>(
      selector: (state) => state.commentErrorMessages[widget.reviewId],
      builder: (context, errorMessage) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "أضف ردك على التقييم",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                errorText: errorMessage,
                hintText: "أدخل ردك هنا...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 1.h,
                  horizontal: 2.w,
                ),
              ),
              onChanged: (value) {
                cubit.onCommentFieldChanged(value, widget.reviewId);
              },
            ),
            SizedBox(height: 1.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Qcolors.getCurrentColor(context),
              ),
              onPressed: () {
                cubit.submitWorkshopComment(widget.reviewId, _controller.text);
              },
              child: const Text("إرسال الرد"),
            ),
          ],
        );
      },
    );
  }
}
