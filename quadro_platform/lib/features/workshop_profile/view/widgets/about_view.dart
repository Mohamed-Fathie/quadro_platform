import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

import '../../cubit/workshop_profile_cubit.dart';
import 'brands_list.dart';
import 'package:readmore/readmore.dart';

import 'spare_parts.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final workshop = context.select(
      (WorkshopProfileCubit value) => value.state.workshop,
    );
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        spacing: 25,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "وصف الورشة",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Qcolors.primarycolor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Divider(
            color: Qcolors.primarycolor,
            thickness: 2,
          ),
          ReadMoreText(
            workshop!.description,
            trimLength: 50,
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimCollapsedText: '...عرض المزيد',
            trimExpandedText: 'عرض أقل',
            colorClickableText: Qcolors.primarycolor,
            style: const TextStyle().copyWith(
              fontWeight: FontWeight.w900, // Medium font
              fontSize: 16,
              height: 1.5,
            ),
          ),
          Text(
            "انواع السيارات المتاحة للصيانة",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Qcolors.primarycolor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Divider(
            color: Qcolors.primarycolor,
            thickness: 2,
          ),
          BrandsList(
            brandlist: workshop.carBrands,
          ),
          Text(
            "حالة القطع التي اعمل بها للصيانة",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Qcolors.primarycolor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Divider(
            color: Qcolors.primarycolor,
            thickness: 2,
          ),
          SpareParts(
            partsList: workshop.status,
          ),
        ],
      ),
    );
  }
}
