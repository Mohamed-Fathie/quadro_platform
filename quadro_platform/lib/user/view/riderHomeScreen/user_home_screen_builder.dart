import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:quadro_platform/commonn/model/profile_data_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/driver/view/DriverHomeScreen/driver_home_screen.dart';
import 'package:quadro_platform/driver/view/DriverHomeScreen/trip_screenn.dart';
import 'package:quadro_platform/user/view/bookRideScreen/book_ride_screen.dart';
import 'package:quadro_platform/user/view/riderHomeScreen/user_home_screen.dart';

class UserHomeScreenBuilder extends StatefulWidget {
  const UserHomeScreenBuilder({super.key});

  @override
  State<UserHomeScreenBuilder> createState() => _UserHomeScreenBuilderState();
}

class _UserHomeScreenBuilderState extends State<UserHomeScreenBuilder> {
  DatabaseReference userRideRequestRef = FirebaseDatabase.instance
      .ref()
      .child('RideRequest/${auth.currentUser!.uid}');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userRideRequestRef.onValue,
        builder: (context, event) {
          if (event.connectionState == ConnectionState.waiting) {
            return const UserHomeScreen();
          }
          if (event.data!.snapshot.value != null) {
            log('the Data for user builder is :');
            log(event.data!.snapshot.value.toString());

            return BookRideScreen();
          } else {
            return const UserHomeScreen();
          }
        });
  }
}
