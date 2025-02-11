// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/commonn/controller/services/APIS&KEYS/apis.dart';
import 'package:quadro_platform/commonn/controller/services/toast_services.dart';
import 'package:quadro_platform/commonn/model/direction_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/driver/controller/provider/driver_ride_request_provider.dart';

import '../../../../user/controller/provider/trip_providerr/ride_request_provider.dart';

class DirectionServices {
  static Future getDirectionDetailsForRider(
      LatLng pickupLocation, LatLng dropLocation, BuildContext context) async {
    final api = Apis.directionAPI(pickupLocation, dropLocation);
    log("below the diarction");
    try {
      var response = await dio.get(api).timeout(const Duration(seconds: 60),
          onTimeout: () {
        ToastService.sendScaffoldAlert(
            msg: 'انتهت صلاحية الجلسة , حاول بعد قليل',
            toastStatus: 'ERROR',
            context: context);
        throw TimeoutException('انتهت صلاحية الجلسة');
      }).onError(
        (error, stackTrace) {
          log(error.toString());
          throw Exception(error);
        },
      );

      if (response.statusCode == 200) {
        var decodedResponse = response.data;
        log(decodedResponse.toString());
        DirectionModel directionModel = DirectionModel(
          distanceInKM: decodedResponse['routes'][0]['legs'][0]['distance']
              ['text'],
          distanceInMeter: decodedResponse['routes'][0]['legs'][0]['distance']
              ['value'],
          durationInHour: decodedResponse['routes'][0]['legs'][0]['duration']
              ['text'],
          duration: decodedResponse['routes'][0]['legs'][0]['duration']
              ['value'],
          polylinePoints: decodedResponse['routes'][0]['overview_polyline']
              ['points'],
        );
        log('direction model${directionModel.toMap().toString()}');
        context.read<RideRequestProvider>().updateDirection(directionModel);
      }
    } catch (e) {
      log(e.toString());
      ToastService.sendScaffoldAlert(
          msg: 'انتهت صلاحية الجلسة , حاول بعد قليل',
          toastStatus: e.toString(),
          context: context);
    }
  }

  static Future getDirectionDetailsForDriver(
      LatLng pickupLocation, LatLng dropLocation, BuildContext context) async {
    final api = Apis.directionAPI(pickupLocation, dropLocation);

    try {
      var response = await dio.get(api).timeout(const Duration(seconds: 60),
          onTimeout: () {
        ToastService.sendScaffoldAlert(
            msg: 'انتهت صلاحية الجلسة , حاول بعد قليل',
            toastStatus: 'ERROR',
            context: context);
        throw TimeoutException('انتهت صلاحية الجلسة');
      }).onError(
        (error, stackTrace) {
          log('error : ${error.toString()}');
          throw Exception(error);
        },
      );
      log('log(response.statusCode): ${response.statusCode.toString()}');
      if (response.statusCode == 200) {
        var decodedResponse = response.data;
        log('decodedResponse: ${decodedResponse.toString()}');
        if (decodedResponse['routes'].isEmpty) {
          log('No routes found between the given locations.');
          ToastService.sendScaffoldAlert(
              msg: 'لا توجد مسارات متاحة بين المواقع المختارة',
              toastStatus: 'INFO',
              context: context);
          return;
        }
        DirectionModel directionModel = DirectionModel(
          distanceInKM: decodedResponse['routes'][0]['legs'][0]['distance']
              ['text'],
          distanceInMeter: decodedResponse['routes'][0]['legs'][0]['distance']
              ['value'],
          durationInHour: decodedResponse['routes'][0]['legs'][0]['duration']
              ['text'],
          duration: decodedResponse['routes'][0]['legs'][0]['duration']
              ['value'],
          polylinePoints: decodedResponse['routes'][0]['overview_polyline']
              ['points'],
        );
        log('points : ${directionModel.toMap().toString()}');
        context
            .read<DriverRideRequestProvider>()
            .updateDirection(directionModel);
      }
    } catch (e) {
      log('error :${e.toString()}');
      throw Exception(e);
    }
  }
}
