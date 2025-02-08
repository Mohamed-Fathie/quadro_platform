import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/services/direction_services.dart';
import 'package:quadro_platform/common/controller/services/location_services.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:quadro_platform/common/model/rider_request_model.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/driver/controller/provider/driver_ride_request_provider.dart';
import 'package:quadro_platform/driver/controller/services/rideRequestServicesForDriver/ride_request_services_for_driver.dart';
import 'package:sizer/sizer.dart';

class TripScreen extends StatefulWidget {
  TripScreen({super.key, required this.rideID});
  final String rideID;
  @override
  State<TripScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<TripScreen> {
  final Completer<GoogleMapController> driverMapController = Completer();
  GoogleMapController? mapController;
  String? rideID;

  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      rideID = context.read<DriverRideRequestProvider>().riderrID!;
      log('the ride ID is: ${rideID.toString()}');

      // LatLng currentLocation = await LocationServices.getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100.w, 14.h),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child('RideRequest/${widget.rideID}')
                    .onValue,
                builder: (context, event) {
                  if (event.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: teal,
                      ),
                    );
                  }
                  if (event.data != null) {
                    RiderRequistModel riderRequestdata =
                        RiderRequistModel.fromMap(jsonDecode(
                      jsonEncode(event.data!.snapshot.value),
                    ) as Map<String, dynamic>);
                    if (riderRequestdata.rideStatus ==
                        RideRequestServicesForDriver.getRideStatus(1)) {
                      return Padding(
                        padding: EdgeInsets.only(right: 5.w, left: 5.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          textStyle: AppTextStyles.body14,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12.sp),
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeFillColor: white,
                              inactiveColor: greyShade3,
                              inactiveFillColor: greyShade3,
                              selectedFillColor: white,
                              selectedColor: teal,
                              activeColor: teal),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: transparent,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: otpController,
                          onCompleted: (value) async {
                            if (otpController.text.trim() ==
                                context
                                    .read<DriverRideRequestProvider>()
                                    .rideRequestData!
                                    .otp) {
                              ToastService.sendScaffoldAlert(
                                msg: 'تم تسجيل الرحلة بنجاح ، طريق السلامة',
                                toastStatus: 'SUCCESS',
                                context: context,
                              );
                              LatLng pickupLocation =
                                  await LocationServices.getCurrentLocation();
                              LatLng dropLocation = LatLng(
                                  context
                                      .read<DriverRideRequestProvider>()
                                      .dropLocation!
                                      .latitude!,
                                  context
                                      .read<DriverRideRequestProvider>()
                                      .dropLocation!
                                      .longitude!);

                              await DirectionServices
                                  .getDirectionDetailsForDriver(
                                      pickupLocation, dropLocation, context);
                              context
                                  .read<DriverRideRequestProvider>()
                                  .decodePolylineAndUpdatePolylineField();
                              context
                                  .read<DriverRideRequestProvider>()
                                  .updateUpdateMarkerStatus(true);
                              context
                                  .read<DriverRideRequestProvider>()
                                  .updateMovingFromCurrentLocationToPickupLocationStatus(
                                      false);
                              context
                                  .read<DriverRideRequestProvider>()
                                  .updateMarker();

                              RideRequestServicesForDriver
                                  .updateRideRequestStatus(
                                      RideRequestServicesForDriver
                                          .getRideStatus(2),
                                      rideID!);
                            } else {
                              ToastService.sendScaffoldAlert(
                                msg: 'رقم Otp خاطئ',
                                toastStatus: 'WARNING',
                                context: context,
                              );
                            }
                          },
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      );
                    } else {
                      return SwipeButton(
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
                        onSwipe: () async {
                          await RideRequestServicesForDriver.endRide(
                              rideID!, context);

                          // DatabaseReference rideRefFechData =
                          //     FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
                          //     final snapshot = await rideRefFechData.get();
                        },
                        child: Builder(
                          builder: (context) {
                            return Text(
                              'انهاء الرحلة',
                              style: AppTextStyles.Mbody18Bold,
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: teal,
                      ),
                    );
                  }
                }),
          ),
        ),
        body: Consumer<DriverRideRequestProvider>(
          builder: (context, rideRequestProvider, child) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
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
                    markers: rideRequestProvider.driverMarker,
                    onMapCreated: (GoogleMapController controller) async {
                      driverMapController.complete(controller);
                      mapController = controller;

                      LatLng pickupLocation = LatLng(
                          rideRequestProvider.rideAcceptLocation!.latitude,
                          rideRequestProvider.rideAcceptLocation!.longitude);
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
