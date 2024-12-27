import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/services/location_services.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/driver/controller/provider/driver_maps_provider.dart';
import 'package:quadro_platform/driver/controller/services/geo_fire_services.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class DriverHomeScreen extends StatelessWidget {
  DriverHomeScreen({super.key});

  final Completer<GoogleMapController> driverMapController = Completer();
  GoogleMapController? mapController;
  DatabaseReference driverProfileRef =
      FirebaseDatabase.instance.ref().child('User/${auth.currentUser!.uid}');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100.w, 10.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
            child: StreamBuilder(
              stream: driverProfileRef.onValue,
              builder: (context, event) {
                if (event.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: teal,
                    ),
                  );
                }
                if (event.data == null) {
                  return SwipeButton(
                    thumbPadding: EdgeInsets.all(1.3.w),
                    thumb: Icon(
                      Icons.chevron_right,
                      color: white,
                    ),
                    inactiveThumbColor: teal,
                    activeThumbColor: teal,
                    inactiveTrackColor: grey,
                    activeTrackColor: grey,
                    elevationThumb: 2,
                    elevationTrack: 2,
                    onSwipe: () {
                      log('swipe');
                      GeoFireServices.goOnline();
                      GeoFireServices.updateLocationRealTime(context);
                    },
                    child: Builder(
                      builder: (context) {
                        return Text(
                          'اسحب للأتصال',
                          style: AppTextStyles.Mbody18Bold,
                        );
                      },
                    ),
                  );
                }
                if (event.data != null) {
                  ProfileDataModel profileData =
                      ProfileDataModel.fromMap(jsonDecode(
                    jsonEncode(event.data!.snapshot.value),
                  ) as Map<String, dynamic>);
                  if (profileData.driverStatus == 'Online') {
                  return  SwipeButton(
                      thumbPadding: EdgeInsets.all(1.3.w),
                      thumb: Icon(
                        Icons.chevron_right,
                        color: white,
                      ),
                      inactiveThumbColor: teal,
                      activeThumbColor: teal,
                      inactiveTrackColor: grey,
                      activeTrackColor: grey,
                      elevationThumb: 2,
                      elevationTrack: 2,
                      onSwipe: () {
                        log('swipe');
                        GeoFireServices.goOffline(context);
                      },
                      child: Builder(
                        builder: (context) {
                          return Text(
                            'اسحب لالغاءالاتصال',
                            style: AppTextStyles.Mbody18Bold,
                          );
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
                      inactiveThumbColor: teal,
                      activeThumbColor: teal,
                      inactiveTrackColor: grey,
                      activeTrackColor: grey,
                      elevationThumb: 2,
                      elevationTrack: 2,
                      onSwipe: () {
                        log('swipe');
                        GeoFireServices.goOnline();
                        GeoFireServices.updateLocationRealTime(context);
                      },
                      child: Builder(
                        builder: (context) {
                          return Text(
                            'اسحب للأتصال',
                            style: AppTextStyles.Mbody18Bold,
                          );
                        },
                      ),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: teal,
                  ),
                );
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Consumer<DriverMapsProvider>(
              builder: (context, mapProvider, child) {
                return GoogleMap(
                  initialCameraPosition: mapProvider.initialCameraPosition,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: (GoogleMapController controller) async {
                    driverMapController.complete(controller);
                    mapController = controller;
                    LatLng currentLocation =
                        await LocationServices.getCurrentLocation();
                    CameraPosition cameraPosition = CameraPosition(
                      target: currentLocation,
                      zoom: 18,
                    );
                    mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
