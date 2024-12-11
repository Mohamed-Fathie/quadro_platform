import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/commonWidgets/activiyt_records.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class RiderActivityScreen extends StatelessWidget {
  const RiderActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quadro',
          style: AppTextStyles.heading20Bold,
        ),
      ),
      body: const ActiviytRecords()
    );
  }
}
