import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:quadro_platform/common/modele/profile_data_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/driver/view/DriverHomeScreen/driver_home_screen.dart';
import 'package:quadro_platform/driver/view/DriverHomeScreen/trip_screenn.dart';

class DriverHomeScreenBuilder extends StatefulWidget {
  const DriverHomeScreenBuilder({super.key});

  @override
  State<DriverHomeScreenBuilder> createState() => _HomeScreenBuilderState();
}

class _HomeScreenBuilderState extends State<DriverHomeScreenBuilder> {
  DatabaseReference driverProfileRef =
      FirebaseDatabase.instance.ref().child('User/${auth.currentUser!.uid}');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: driverProfileRef.onValue,
        builder: (context, event) {
          if (event.connectionState == ConnectionState.waiting) {
            return DriverHomeScreen();
          }
          if (event.data != null) {
            ProfileDataModel profileData = ProfileDataModel.fromMap(jsonDecode(
              jsonEncode(event.data!.snapshot.value),
            ) as Map<String, dynamic>);
            if (profileData.activeRideRequestID != null) {
              return TripScreen(
                rideID: profileData.activeRideRequestID!,
              );
            } else {
              return DriverHomeScreen();
            }
          } else {
            return DriverHomeScreen();
          }
        });
  }
}
