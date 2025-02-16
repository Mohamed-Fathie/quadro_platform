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

  DatabaseReference tripHistory = FirebaseDatabase.instance
      .ref()
      .child('DriverRideHistory/${auth.currentUser!.uid}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'النشاطات',
            style: AppTextStyles.Mheading20Bold,
          ),
        ),
        body: StreamBuilder(
          stream: tripHistory.onValue,
          builder: (context, event) {
            if (event.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: teal,
                ),
              );
            }
            if (event.data != null) {
              return FirebaseAnimatedList(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  query: tripHistory,
                  itemBuilder: (context, snapshot, animation, index) {
                    RiderRequistModel rideData = RiderRequistModel.fromMap(
                        jsonDecode(jsonEncode(snapshot.value))
                            as Map<String, dynamic>);
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: index == 9 ? transparent : greyShade3),
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
                                  getVehicleImage(rideData.vehicleType),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
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
                                  rideData.dropLocation.name!,
                                  style: AppTextStyles.Mbody16Bold,
                                  maxLines: 2,
                                ),
                                Text(
                                  DateFormat('dd MMMM، hh:mm a', 'ar')
                                      .format(rideData.rideCreateTime),
                                  style: AppTextStyles.Mbody14Bold.copyWith(
                                      color: black87),
                                ),
                                Text(
                                  '${rideData.fare} د.ل',
                                  style: AppTextStyles.Mbody14Bold.copyWith(
                                      color: black87),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return Center(
              child: Text(
                'لا توجد رحلات سابقة.',
                style: AppTextStyles.Mbody16Bold.copyWith(color: teal),
              ),
            );
          },
        ));
  }
}
