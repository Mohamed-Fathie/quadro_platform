import 'package:flutter/material.dart';
import 'package:quadro_platform/features/offers_screen/view/widgets/offers_page.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';

class WorkshopOfferPage extends StatelessWidget {
  const WorkshopOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OffersPage(requestType: RequestType.workshop_id);
  }
}
