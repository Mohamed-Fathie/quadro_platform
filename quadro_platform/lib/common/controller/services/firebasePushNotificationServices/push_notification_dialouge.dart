import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/services/location_services.dart';
import 'package:quadro_platform/common/model/rider_request_modele.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/driver/controller/provider/driver_ride_request_provider.dart';
import 'package:quadro_platform/driver/controller/services/rideRequestServicesForDriver/ride_request_services_for_driver.dart';
import 'package:sizer/sizer.dart';

import 'direction_services.dart';

class PushNotificationDialouge {
  static RideRequestDilouge(
      String rideID, RiderRequistModel rideRequestModel, BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          audioPlayer.setAsset('assets/sounds/alert.mp3');
          audioPlayer.play();
          RideRequestServicesForDriver.checkRideAvailability(
            context,
            rideID,
          );
          return AlertDialog(
            content: SizedBox(
              height: 55.h,
              width: 70.w,
              child: Column(
                children: [
                  Builder(builder: (context) {
                    if (rideRequestModel.vehicleType == 'سيارة جر') {
                      return Image(
                        image: const AssetImage(
                          'assets/images/vehicle/hookTruck.png',
                        ),
                        height: 5.h,
                      );
                    } else if (rideRequestModel.vehicleType == 'سيارة سحب') {
                      return Image(
                        image: const AssetImage(
                            'assets/images/vehicle/towingTruck.png'),
                        height: 5.h,
                      );
                    } else {
                      return Image(
                        image: const AssetImage(
                            'assets/images/vehicle/integrationTruck.png'),
                        height: 5.h,
                      );
                    }
                  }),
                  SizedBox(
                    height: 3.w,
                  ),
                  Text(
                    'طلب سحب',
                    style: AppTextStyles.Mbody18Bold,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    '${rideRequestModel.fare!} السعر ',
                    maxLines: 2,
                    style: AppTextStyles.Mbody16Bold,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.h,
                        child: const Image(
                          image:
                              AssetImage('assets/images/icons/pickupPng.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Text(
                          '${rideRequestModel.pickupLocation.name!} من ',
                          maxLines: 2,
                          style: AppTextStyles.Mbody16Bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.h,
                        child: const Image(
                          image: AssetImage('assets/images/icons/dropPng.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: Text(
                          '${rideRequestModel.dropLocation.name!}  الى ',
                          maxLines: 2,
                          style: AppTextStyles.body16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Consumer<DriverRideRequestProvider>(
                    builder: (context, driverProvider, child) {
                      return SwipeButton(
                        thumbPadding: EdgeInsets.all(1.3.w),
                        thumb: Icon(
                          Icons.chevron_right,
                          color: white,
                        ),
                        inactiveThumbColor: success,
                        activeThumbColor: success,
                        inactiveTrackColor: grey,
                        activeTrackColor: grey,
                        elevationThumb: 2,
                        elevationTrack: 2,
                        onSwipe: () async {
                          driverProvider.setLoading(true); // تفعيل التحميل

                          try {
                            driverProvider.updateRideRequestData(
                                rideRequestModel, rideID);
                            driverProvider.updateTripPickupAndDropLocation(
                              rideRequestModel.pickupLocation,
                              rideRequestModel.dropLocation,
                            );
                            driverProvider.createIcons(context);

                            LatLng currentDriverLocation =
                                await LocationServices.getCurrentLocation();
                            driverProvider.updateRideAcceptLocation(
                                currentDriverLocation);

                            LatLng pickupLocation = LatLng(
                              rideRequestModel.pickupLocation.latitude!,
                              rideRequestModel.pickupLocation.longitude!,
                            );

                            await DirectionServices
                                .getDirectionDetailsForDriver(
                                    currentDriverLocation,
                                    pickupLocation,
                                    context);

                            driverProvider
                                .decodePolylineAndUpdatePolylineField();
                            driverProvider.updateUpdateMarkerStatus(true);
                            driverProvider
                                .updateMovingFromCurrentLocationToPickupLocationStatus(
                                    true);
                            driverProvider.updateMarker();

                            RideRequestServicesForDriver.acceptRideRequest(
                                rideID, context);
                            RideRequestServicesForDriver
                                .updateRideRequestStatus(
                                    RideRequestServicesForDriver.getRideStatus(
                                        1),
                                    rideID);
                            RideRequestServicesForDriver.updateRideRequestID(
                                rideID);

                            log('on Swipe rideID : $rideID');

                            audioPlayer.stop();
                            Navigator.pop(context);
                          } finally {
                            driverProvider.setLoading(false); // تعطيل التحميل
                          }
                        },
                        child: driverProvider.isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'قبول طلب السحب',
                                style: AppTextStyles.Mbody18Bold,
                              ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SwipeButton(
                    thumbPadding: EdgeInsets.all(1.3.w),
                    thumb: Icon(
                      Icons.chevron_right,
                      color: white,
                    ),
                    inactiveThumbColor: red,
                    activeThumbColor: red,
                    inactiveTrackColor: grey,
                    activeTrackColor: grey,
                    elevationThumb: 2,
                    elevationTrack: 2,
                    onSwipe: () {
                      audioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Builder(
                      builder: (context) {
                        return Text(
                          'رفض طلب السحب',
                          style: AppTextStyles.Mbody18Bold,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
