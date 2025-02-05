import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/provider/profile_data_provider.dart';
import 'package:quadro_platform/common/model/pickup&drop_location_model.dart';
import 'package:quadro_platform/common/model/rider_request_model.dart';
import 'package:quadro_platform/constants/commonWidgets/custom_elevated_button.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/user/controller/provider/trip_provider/ride_request_provider.dart';
import 'package:quadro_platform/user/controller/services/nearbyDriverServices/nearby_driver_services.dart';
import 'package:quadro_platform/user/controller/services/rideRequestServices/ride_request_service.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math' as math;

class BookRideScreen extends StatefulWidget {
  BookRideScreen({super.key});

  @override
  State<BookRideScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {
  final Completer<GoogleMapController> driverMapController = Completer();
  GoogleMapController? mapController;
  int selectedVehicleType = 0;
  bool bookRideButtonPressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<RideRequestProvider>().updateFetchedNearbyDrivers(true);
      context.read<RideRequestProvider>().updateupdateMarkerBool(true);

      PickupAndDropLocationModel pickupModel =
          context.read<RideRequestProvider>().pickupLocation!;
      LatLng pickupLocation =
          LatLng(pickupModel.latitude!, pickupModel.longitude!);
      await NearbyDriverServices.getNearbyDrivers(pickupLocation, context);
    });
  }

  int getFare(
    int index,
  ) {
    if (index == 0) {
      return context.read<RideRequestProvider>().quadroHookFare;
    }
    if (index == 1) {
      return context.read<RideRequestProvider>().quadroWheelLeftFare;
    }
    if (index == 2) {
      return context.read<RideRequestProvider>().quadroIntegratedTowFare;
    }

    return 0;
  }

  getVehicleType(int vehicleType) {
    switch (vehicleType) {
      case 0:
        return 'سيارة جر';
      case 1:
        return 'سيارة سحب';
      case 2:
        return 'نقل ثقيل';
      default:
        return 'سيارة جر';
    }
  }

  List ridesList = [
    ['assets/images/vehicle/hookTruck.png', 'سيارة جر', 'من 1 الى 3 طن'],
    ['assets/images/vehicle/towingTruck.png', 'سيارة سحب', 'من 3 الى 5 طن'],
    [
      'assets/images/vehicle/integrationTruck.png',
      'نقل ثقيل',
      'من 5 الى 10 طن'
    ],
  ];
  DatabaseReference userRideRequestRef = FirebaseDatabase.instance
      .ref()
      .child('RideRequest/${auth.currentUser!.uid}');

  final panelController = PanelController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 12.h,
        maxHeight: 80.h,
        controller: panelController,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            15.sp,
          ),
        ),
        panelBuilder: (controller) {
          return Consumer<RideRequestProvider>(
              builder: (context, rideRequestProvider, child) {
            if (rideRequestProvider.placeRideRequest == false) {
              return Builder(
                builder: (context) {
                  if (bookRideButtonPressed == true) {
                    return CancelRideRequest(
                      controller: controller,
                    );
                  } else {
                    return Consumer<RideRequestProvider>(
                      builder: (context, rideRequestProvider, child) {
                        if ((rideRequestProvider.quadroHookFare == 0) &&
                            (rideRequestProvider.quadroWheelLeftFare == 0) &&
                            (rideRequestProvider.quadroIntegratedTowFare ==
                                0)) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: teal,
                            ),
                          );
                        } else {
                          return ListView(
                            controller: controller,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 2.h),
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 1.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.sp),
                                          color: grey),
                                    ),
                                  ]),
                              SizedBox(
                                height: 2.h,
                              ),
                              ListView.builder(
                                  itemCount: ridesList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedVehicleType = index;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 0.4.h),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 1.h,
                                          horizontal: 1.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.sp),
                                          border: Border.all(
                                              color:
                                                  index == selectedVehicleType
                                                      ? teal
                                                      : transparent,
                                              width: 2),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 7.h,
                                              width: 7.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.sp),
                                                border: Border.all(color: teal),
                                                color: white,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    ridesList[index][0],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    getVehicleType(index),
                                                    style: AppTextStyles
                                                        .Mbody18Bold,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    width: 2.5.w,
                                                  ),
                                                  Icon(
                                                    Icons.scale_rounded,
                                                    color: teal,
                                                  ),
                                                  Text(
                                                    ' ${ridesList[index][2]}',
                                                    style: AppTextStyles
                                                            .Mbody14Bold
                                                        .copyWith(color: teal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  getFare(index).toString(),
                                                  style:
                                                      AppTextStyles.Mbody18Bold,
                                                ),
                                                Text(
                                                  'د.ل ${(getFare(index) * 1.15).round().toString()}',
                                                  style: AppTextStyles
                                                      .Mbody16Bold.copyWith(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBox(
                                height: 1.h,
                              ),
                              CustomElevatedButton(
                                buttonTitle: 'استمرار',
                                fontSize: 20,
                                fontColor: white,
                                onPressed: () {
                                  context
                                      .read<RideRequestProvider>()
                                      .updatePlaceRideRequestStatus(true);
                                  setState(() {
                                    bookRideButtonPressed = true;
                                  });
                                  RiderRequistModel model = RiderRequistModel(
                                    rideCreateTime: DateTime.now(),
                                    userProfile: context
                                        .read<ProfileDataProvider>()
                                        .profileData!,
                                    pickupLocation: context
                                        .read<RideRequestProvider>()
                                        .pickupLocation!,
                                    dropLocation: context
                                        .read<RideRequestProvider>()
                                        .dropLocation!,
                                    fare:
                                        getFare(selectedVehicleType).toString(),
                                    vehicleType:
                                        getVehicleType(selectedVehicleType),
                                    rideStatus:
                                        RideRequestService.getRideStatus(0),
                                    otp: math.Random().nextInt(9999).toString(),
                                  );
                                  RideRequestService.createNewRideRequest(
                                      model, context);
                                  context
                                      .read<RideRequestProvider>()
                                      .sendPushNotificationToNearbyDrivers();
                                },
                                child: Builder(builder: (context) {
                                  if (bookRideButtonPressed == true) {
                                    return CircularProgressIndicator(
                                      color: white,
                                    );
                                  } else {
                                    return Text(
                                      'استمرار',
                                      style: AppTextStyles.Mbody18Bold.copyWith(
                                          color: white),
                                    );
                                  }
                                }),
                              )
                            ],
                          );
                        }
                      },
                    );
                  }
                },
              );
            } else {
              return StreamBuilder(
                stream: userRideRequestRef.onValue,
                builder: (context, event) {
                  if ((event.connectionState == ConnectionState.waiting) ||
                      (event.data == null)) {
                    return ListView(
                      shrinkWrap: true,
                      controller: controller,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: teal,
                          ),
                        ),
                      ],
                    );
                  }
                  if (event.data != null) {
                    log('not null');
                    if (event.data!.snapshot.value != null) {
                      RiderRequistModel rideData = RiderRequistModel.fromMap(
                        jsonDecode(
                          jsonEncode(event.data!.snapshot.value),
                        ) as Map<String, dynamic>,
                      );
                     
                      if (rideData.driverProfile == null) {
                        return CancelRideRequest(
                          controller: controller,
                        );
                      }
                      if (rideData.rideStatus ==
                          RideRequestService.getRideStatus(0)) {
                        return RideData(
                          rideData: rideData,
                          controller: controller,
                        );
                      } else if (rideData.rideStatus ==
                          RideRequestService.getRideStatus(1)) {
                        return RideData(
                          rideData: rideData,
                          controller: controller,
                        );
                      } else {
                        RideData(
                          rideData: rideData,
                          controller: controller,
                        );
                      }
                    }
                  }
                  return CancelRideRequest(controller: controller);
                },
              );
            }
          });
        },
        body: Consumer<RideRequestProvider>(
          builder: (context, rideRequestProvider, child) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition:
                        rideRequestProvider.initialCameraPosition,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    polylines: rideRequestProvider.polylineSet,
                    markers: rideRequestProvider.riderMarker,
                    onMapCreated: (GoogleMapController controller) async {
                      driverMapController.complete(controller);
                      mapController = controller;

                      LatLng pickupLocation = LatLng(
                          rideRequestProvider.pickupLocation!.latitude!,
                          rideRequestProvider.pickupLocation!.longitude!);
                      CameraPosition cameraPosition = CameraPosition(
                        target: pickupLocation,
                        zoom: 14,
                      );
                      mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition),
                      );
                    },
                  ),
                  Positioned(
                    top: 3.h,
                    left: 5.w,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 5.h,
                        width: 5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: white,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: teal,
                          size: 4.h,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RideData extends StatelessWidget {
  const RideData({super.key, required this.rideData, required this.controller});

  final RiderRequistModel rideData;
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1.h,
              width: 20.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp), color: grey),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 70.w,
              child: Text(
                rideData.driverProfile!.name!,
                style: AppTextStyles.Mheading26Bold,
              ),
            ),
            Container(
              height: 18.w,
              width: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: black87),
                image: DecorationImage(
                  image: NetworkImage(rideData.driverProfile!.profilePicUrl!),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'نقطة البداية',
              style: AppTextStyles.Mbody16Bold,
            ),
            Text(
              rideData.pickupLocation.name!,
              style: AppTextStyles.Mbody16Bold,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'نقطة النهاية',
              style: AppTextStyles.Mbody16Bold,
            ),
            Text(
              rideData.dropLocation.name!,
              style: AppTextStyles.Mbody16Bold,
            )
          ],
        ),
        Row(
          children: [
            Text(
              'نوع المركبة',
              style: AppTextStyles.Mbody16Bold,
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              rideData.vehicleType,
              style: AppTextStyles.Mbody16Bold,
            ),
            Builder(builder: (context) {
              if (rideData.vehicleType == 'سيارة جر') {
                return Image(
                  image: const AssetImage(
                    'assets/images/vehicle/hookTruck.png',
                  ),
                  height: 5.h,
                );
              } else if (rideData.vehicleType == 'سيارة سحب') {
                return Image(
                  image:
                      const AssetImage('assets/images/vehicle/towingTruck.png'),
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
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          '${rideData.driverProfile!.vehicleBrandName!} ${rideData.driverProfile!.vehicleModel!}',
          style: AppTextStyles.Mbody16Bold,
        ),
        Text(
          rideData.driverProfile!.vehicleRegistrationNumber!,
          style: AppTextStyles.Mbody16Bold,
        ),
      ],
    );
  }
}

class CancelRideRequest extends StatelessWidget {
  const CancelRideRequest({super.key, required this.controller});
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: teal,
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        InkWell(
          onTap: () async {
            await RideRequestService.cancelRideRequest(context);
          },
          child: Container(
            height: 8.h,
            width: 8.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: teal,
                  width: 2,
                ),
                color: white),
            child: Icon(
              CupertinoIcons.xmark,
              color: teal,
              size: 6.h,
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'الغاء الرحلة',
          textAlign: TextAlign.center,
          style: AppTextStyles.body16Bold,
        ),
      ],
    );
  }
}
