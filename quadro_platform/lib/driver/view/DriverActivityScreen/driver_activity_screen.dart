import 'package:flutter/material.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/shared/widgets/activiyt_records.dart';

class DriverActivityScreen extends StatelessWidget {
  const DriverActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'النشاطات',
          style: AppTextStyles.Mheading20Bold,
        ),
      ),
      body: const ActiviytRecords()
    );
  }
}