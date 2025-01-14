import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/utils/colors.dart';
import '../../../../shared/utils/constans/colors.dart';
import '../../cubit/workshop_offers_cubit.dart';
import 'list_of_offers.dart';

class OffersListView extends StatelessWidget {
  final WorkshopOffersState state;

  const OffersListView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case WorkshopOfferFetchloading():
        return _buildLoadingIndicator();
      case WorkshopOfferFetchAllSuccess():
        return ListOfOffers(
            offers: (state as WorkshopOfferFetchAllSuccess).allOffers);
      case WorkshopOfferFetchInprogressSuccess():
        return ListOfOffers(
            offers: (state as WorkshopOfferFetchInprogressSuccess)
                .inprogressOffers);
      case WorkshopOfferFetchPendingSuccess():
        return ListOfOffers(
            offers: (state as WorkshopOfferFetchPendingSuccess).pendingOffers);
      case WorkshopOfferFetchFailure():
        return _buildError((state as WorkshopOfferFetchFailure).error);
      case WorkshopRequestSuccess():
        return ListOfOffers(offers: (state as WorkshopRequestSuccess).requests);
    }
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 50.h,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 1.h,
          color: Qcolors.primarycolor,
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Text(
        error,
        style: TextStyle(
          color: red,
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
