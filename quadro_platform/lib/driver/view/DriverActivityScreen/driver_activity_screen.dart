import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quadro_platform/common/model/rider_request_modele.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/shared/widgets/activiyt_records.dart';
import 'package:sizer/sizer.dart';

class DriverActivityScreen extends StatefulWidget {
  const DriverActivityScreen({super.key});

  @override
  State<DriverActivityScreen> createState() => _DriverActivityScreenState();
}

class _DriverActivityScreenState extends State<DriverActivityScreen> {
  DatabaseReference tripHistory = FirebaseDatabase.instance
      .ref()
      .child('DriverRideHistory/${auth.currentUser!.uid}');
  getVehicleImage(String vehicleType) {
    switch (vehicleType) {
      case 'سيارة جر':
        return 'assets/images/vehicle/hookTruck.png';
      case 'سيارة سحب':
        return 'assets/images/vehicle/towingTruck.png';
      default:
        return 'assets/images/vehicle/integrationTruck.png';
    }
  }

  Future<List<RiderRequistModel>> fetchSortedTrips() async {
    DatabaseEvent event = await tripHistory.once();

    if (event.snapshot.value == null) return [];

    List<RiderRequistModel> trips = (event.snapshot.value as Map)
        .entries
        .map((e) => RiderRequistModel.fromMap(
              jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>,
            ))
        .toList();

    trips.sort((a, b) => b.rideCreateTime.compareTo(a.rideCreateTime));

    return trips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'النشاطات',
            style: AppTextStyles.Mheading20Bold,
          ),
        ),
        body: FutureBuilder<List<RiderRequistModel>>(
          future: fetchSortedTrips(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: teal),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text("حدث خطأ أثناء جلب البيانات"));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد رحلات سابقة.',
                  style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
                ),
              );
            }

            List<RiderRequistModel> trips = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                RiderRequistModel rideData = trips[index];

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 1.7.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: index == trips.length - 1
                              ? transparent
                              : greyShade3),
                    ),
                  ),
                  height: 17.6.h,
                  width: 94.w,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5.h, horizontal: 1.w),
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.sp),
                          color: white,
                          image: DecorationImage(
                            image: AssetImage(
                                getVehicleImage(rideData.vehicleType)),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              rideData.pickupLocation.name!,
                              style: AppTextStyles.Mbody16Bold,
                              maxLines: 2,
                            ),
                            Text(
                              DateFormat('dd MMMM، hh:mm a', 'ar')
                                  .format(rideData.rideCreateTime),
                              style: AppTextStyles.Mbody16Bold.copyWith(
                                  color: black87),
                            ),
                            Text(
                              '${rideData.fare} د.ل',
                              style: AppTextStyles.Mbody16Bold.copyWith(
                                  color: black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
