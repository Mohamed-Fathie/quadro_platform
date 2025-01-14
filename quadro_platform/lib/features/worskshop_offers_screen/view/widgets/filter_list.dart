import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/worskshop_offers_screen/cubit/workshop_offers_cubit.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/offers_filter.dart';
import '../../../../shared/utils/constans/colors.dart';

class FilterList extends StatelessWidget {
  const FilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 5.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: OffersFilter.values.length,
          separatorBuilder: (context, index) => SizedBox(width: 5.w),
          itemBuilder: (context, index) {
            return BlocSelector<WorkshopOffersCubit, WorkshopOffersState, int>(
              selector: (state) {
                return state.index;
              },
              builder: (context, state) {
                final isSelected = state == index;

                return InkWell(
                  onTap: () {
                    context.read<WorkshopOffersCubit>().handleOfferFilterChange(
                        index, RequestType.workshop_id);
                  },
                  borderRadius: BorderRadius.circular(
                      4.w), // Matches the container's border radius
                  splashColor:
                      Colors.tealAccent.withAlpha(77), // 77 = 30% opacity
                  highlightColor: Qcolors.primarycolor.withAlpha(25),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Qcolors.primarycolor
                          : Qcolors.getCurrentColor(context),
                      borderRadius: BorderRadius.circular(4.w),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Qcolors.primarycolor
                                .withAlpha(128), // Shadow when selected
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w), // Adjust padding for spacing
                    alignment:
                        Alignment.center, // Ensure text is centered vertically
                    child: Text(OffersFilter.values[index].label,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : Qcolors.primarycolor,
                            )),
                  ),
                );
              },
            );
          },
        ));
  }
}
