import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/routes/navigation_service.dart';
import '../../../../shared/routes/routes_constants.dart';
import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/widgets/rounded_container.dart';
import '../../bloc/main_screenbloc_bloc.dart';
import '../../../../shared/widgets/request_templet.dart';

class OffersList extends StatelessWidget {
  const OffersList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = context.select((MainScreenBloc bloc) => bloc.state.offers);

    return SizedBox(
      height: 45.h,
      child: BlocSelector<MainScreenBloc, MainScreenState, MainScreenStatus>(
        selector: (state) {
          return state.status;
        },
        builder: (context, state) {
          if (state == MainScreenStatus.offerFailure) {
            const Center(
              child: Text(
                "حدث خطاء في تحميل العروض",
              ),
            );
          }

          return list == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Qcolors.primarycolor,
                  ),
                )
              : list.isEmpty
                  ? RoundedContainer(
                      width: 80.w,
                      height: 35.h,
                      child: Center(
                        child: Text(
                          "لا يوجد عروض حاليا",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(color: Qcolors.primarycolor),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final offer = list[index];
                        return RequestTemplet(
                          isOffer: true,
                          buttonTitle: "تفاصيل",
                          offerStatus: offer.offer!.status.name,
                          servicePrice: offer.offer!.servicePrice.toString(),
                          navigatorCall: () => NavigationService().routeTo(
                              RoutesConstants.requestDetails,
                              arguments: offer),
                          carBrand: offer.carCompany.name,
                          carModel: offer.carModel.name,
                          dateCreated: offer.offer!.dateCreated.toDate(),
                          userName: offer.user.name,
                        );
                      },
                    );
        },
      ),
    );
  }
}
