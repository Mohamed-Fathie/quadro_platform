import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/offers_screen/cubit/offers_cubit.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:sizer/sizer.dart';
import '../../../workshop_main_screen/repository/repository_manager.dart';
import 'filter_list.dart';
import 'offers_list_view.dart';

class OffersPage extends StatelessWidget {
  final RequestType requestType;
  const OffersPage({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OffersCubit(
        context.read<RepositoryManager>(),
      )..handleOfferFilterChange(0, requestType),
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: requestType == RequestType.workshop_id
                ? Text(
                    "العروض",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Qcolors.primarycolor),
                  )
                : Text(
                    "طلبات الصيانة ",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Qcolors.secondary),
                  )),
        body: Padding(
          padding: EdgeInsets.all(4.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 4.w,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                requestType == RequestType.workshop_id
                    ? const SectionHeader(
                        requestType: RequestType.workshop_id,
                        text: "العروض الخاصة بي")
                    : const SectionHeader(
                        requestType: RequestType.workshop_id,
                        text: "عروض الطلبات : "),
                FilterList(
                  requestType: requestType,
                ),
                BlocBuilder<OffersCubit, OffersState>(
                  builder: (context, state) {
                    return OffersListView(
                      requestType: requestType,
                      state: state,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
