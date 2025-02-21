import 'package:flutter/material.dart';
import 'package:quadro_platform/features/offers_screen/view/widgets/offers_page.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';

class UserOfferPage extends StatelessWidget {
  const UserOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OffersPage(requestType: RequestType.vehicle_owner_id);
  }
}
