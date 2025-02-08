import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:quadro_platform/shared/routes/routes_constants.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:quadro_platform/shared/widgets/rating_stars.dart';
import 'package:sizer/sizer.dart';

import '../../model/workshop_model.dart';

class WorkshopList extends StatelessWidget {
  final List<WorkshopModel> workshops;

  const WorkshopList({
    super.key,
    required this.workshops,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: workshops.length,
      itemBuilder: (context, index) {
        final workshopModel = workshops[index];
        final workshop = workshopModel.workshop;

        return Card(
          color: Qcolors.getPrimeryColor(context),
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(2.h),
                    child: Image.network(
                      workshop.imagePath,
                      width: 15.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 60),
                    ),
                  ),
                  title: Text(
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    workshop.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 1.w,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        " ${workshop.city} , ${(workshop.street == "Unknown street" ? "" : workshop.street)} ",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Qcolors.secondary),
                      ),
                      Row(
                        spacing: 1.w,
                        children: [
                          Text(
                            workshopModel.average.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          RatingWidget(rating: workshopModel.average),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: CustomElevatedButton(
                        buttonColor: Qcolors.secondary,
                        buttonTitle: "ارسل طلب",
                        onPressed: () {
                          NavigationService().routeTo(
                              RoutesConstants.maintenanceRequest,
                              arguments: workshop);
                        },
                      ),
                    ),
                    Flexible(
                      child: CustomElevatedButton(
                        iconColor: Qcolors.secondary,
                        buttonColor: Qcolors.getLightColorForRequestType(
                            RequestType.vehicle_owner_id, context),
                        buttonTitle: "تفاصيل",
                        onPressed: () {
                          NavigationService().routeTo(
                              RoutesConstants.workshoProfile,
                              arguments: {
                                "workshop": workshop,
                                "requestType": RequestType.vehicle_owner_id
                              });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
