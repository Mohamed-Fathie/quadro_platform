// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quadro_platform/common/model/pickup&drop_location_model.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';

class RiderRequistModel {
  DateTime riderCreateTime;
  ProfileDataModel userProfile;
  ProfileDataModel? driverProfile;
  PickupAndDropLocationModel pickupLocation;
  PickupAndDropLocationModel dropLocation;
  String fare;
  String rideStatus;
  String vehicleType;
  String otp;
  RiderRequistModel({
    required this.riderCreateTime,
    required this.userProfile,
    this.driverProfile,
    required this.pickupLocation,
    required this.dropLocation,
    required this.fare,
    required this.rideStatus,
    required this.vehicleType,
    required this.otp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'riderCreateTime': riderCreateTime.millisecondsSinceEpoch,
      'userProfile': userProfile.toMap(),
      'driverProfile': driverProfile?.toMap(),
      'pickupLocation': pickupLocation.toMap(),
      'dropLocation': dropLocation.toMap(),
      'fare': fare,
      'rideStatus': rideStatus,
      'carType': vehicleType,
      'otp': otp,
    };
  }

  factory RiderRequistModel.fromMap(Map<String, dynamic> map) {
    return RiderRequistModel(
      riderCreateTime: DateTime.fromMillisecondsSinceEpoch(map['riderCreateTime'] as int),
      userProfile: ProfileDataModel.fromMap(map['userProfile'] as Map<String,dynamic>),
      driverProfile: map['driverProfile'] != null ? ProfileDataModel.fromMap(map['driverProfile'] as Map<String,dynamic>) : null,
      pickupLocation: PickupAndDropLocationModel.fromMap(map['pickupLocation'] as Map<String,dynamic>),
      dropLocation: PickupAndDropLocationModel.fromMap(map['dropLocation'] as Map<String,dynamic>),
      fare: map['fare'] as String,
      rideStatus: map['rideStatus'] as String,
      vehicleType: map['carType'] as String,
      otp: map['otp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RiderRequistModel.fromJson(String source) => RiderRequistModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
