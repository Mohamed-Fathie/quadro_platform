import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/widgets/gradient_circular_progress.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/utils/colors.dart';
import '../../cubit/offers_cubit.dart';
import 'list_of_offers.dart';

class OffersListView extends StatelessWidget {
  final OffersState state;
  final RequestType requestType;

  const OffersListView(
      {super.key, required this.state, required this.requestType});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case OfferFetchloading():
        return _buildLoadingIndicator();
      case OfferFetchAllSuccess():
        return ListOfOffers(
            requestType: requestType,
            offers: (state as OfferFetchAllSuccess).allOffers);
      case OfferFetchInprogressSuccess():
        return ListOfOffers(
            requestType: requestType,
            offers: (state as OfferFetchInprogressSuccess).inprogressOffers);
      case OfferFetchPendingSuccess():
        return ListOfOffers(
            requestType: requestType,
            offers: (state as OfferFetchPendingSuccess).pendingOffers);
      case OfferFetchFailure():
        return _buildError((state as OfferFetchFailure).error);

      case RequestSuccess():
        return ListOfOffers(
            requestType: requestType,
            offers: (state as RequestSuccess).requests);
      case OfferFetchAcceptedSuccess():
        return ListOfOffers(
            requestType: requestType,
            offers: (state as OfferFetchAcceptedSuccess).acceptedOffers);
      case OfferFetchRejectedSuccess():
        return ListOfOffers(
            requestType: requestType,
            offers: (state as OfferFetchRejectedSuccess).rejectedOffers);
      case OfferFetchCompletedSuccess():
        return ListOfOffers(
            requestType: requestType,
            offers: (state as OfferFetchCompletedSuccess).completed);
    }
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(height: 50.h, child: const GradientCircularProgress());
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
