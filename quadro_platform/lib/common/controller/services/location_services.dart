// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/provider/location_provider.dart';
import 'package:quadro_platform/common/controller/services/APIS&KEYS/apis.dart';
import 'package:quadro_platform/common/controller/services/toast_services.dart';
import 'package:dio/dio.dart';
import 'package:quadro_platform/common/model/pickup&drop_location_model.dart';
import 'package:quadro_platform/common/model/searched_address_model.dart';
import 'package:quadro_platform/constants/constants.dart';

class LocationServices {
  static getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        getCurrentLocation;
        // ToastService.sendScaffoldAlert(msg: 'عليك قبول اذونات الموقع لكي تتمكن من استخدام التطبيق', toastStatus: 'WARNING', context: context)
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );
    LatLng currentLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    return currentLocation;
  }

  static Future getAddressFromLatLng(
      {required LatLng position, required BuildContext context}) async {
    final api = Apis.geoCodingAPI(position);
    try {
      var response = await dio.get(api).timeout(const Duration(seconds: 60),
          onTimeout: () {
      
        throw TimeoutException('انتهت صلاحية الجلسة');
      });
      if (response.statusCode == 200) {
        var decodedResponse = response.data;
        PickupAndDropLocationModel model = PickupAndDropLocationModel(
          name: decodedResponse['results'][0]['formatted_address'],
          placeID: decodedResponse['results'][0]['place_id'],
          latitude: position.latitude,
          longitude: position.longitude,
        );
        log('pickup and drop location: ${model.toMap().toString()}');
        context.read<LocationProvider>().updatePickupLocation(model);
        return model;
      } else {
        throw Exception('خطأ في الاستجابة: ${response.statusCode}');
      }
    } catch (e) {
      ToastService.sendScaffoldAlert(
          msg: 'حدث خطأ غير متوقع: $e', toastStatus: 'ERROR', context: context);
      throw Exception(e);
    }
  }

  static Future getSerchedAddress(
      {required String placeName, required BuildContext context}) async {
    List<SearchedAddressModel> address = [];
    final dio = Dio();
    final api = Apis.placesAPI(placeName);
    try {
      var response = await dio.get(api).timeout(const Duration(seconds: 60),
          onTimeout: () {
        ToastService.sendScaffoldAlert(
            msg: 'انتهت صلاحية الجلسة , حاول بعد قليل',
            toastStatus: 'ERROR',
            context: context);
        throw TimeoutException('انتهت صلاحية الجلسة');
      });

      if (response.statusCode == 200) {
        var decodedResponse = response.data;
        for (var data in decodedResponse['predictions']) {
          address.add(SearchedAddressModel(
            mainName: data['structured_formatting']['main_text'],
            secondaryName: data['structured_formatting']['secondary_text'],
            placeID: data['place_id'],
          ));
        }

        log('searched address name API works');
        // ignore: use_build_context_synchronously
        context.read<LocationProvider>().updateSearchedAddress(address);
      } else {
        throw Exception('خطأ في الاستجابة: ${response.statusCode}');
      }
      DioException catcher(dioException) {
        ToastService.sendScaffoldAlert(
            msg: 'خطأ في الاتصال: ${dioException.message}',
            toastStatus: 'ERROR',
            context: context);
        throw Exception('DioException: ${dioException.message}');
      }
    } catch (e) {
      ToastService.sendScaffoldAlert(
          msg: 'حدث خطأ غير متوقع: $e', toastStatus: 'ERROR', context: context);
      
    }
  }

  static getLatLngFromPlaceID(SearchedAddressModel address,
      BuildContext context, String locationType) async {
    final api = Apis.getLatLngFromPlaceIDAPI(address.placeID);

    try {
      var response = await dio.get(api).timeout(const Duration(seconds: 120),
          onTimeout: () {
        
        throw TimeoutException('انتهت صلاحية الجلسة');
      });

      if (response.statusCode == 200) {
        log('Responssssssssssssssssssssssssssssssse: ${response.data.toString()}');
        var decodedResponse = response.data;

        var locationLatLng = decodedResponse['result']['geometry']['location'];
        PickupAndDropLocationModel model = PickupAndDropLocationModel(
          name: address.mainName,
          description: address.secondaryName,
          placeID: address.placeID,
          latitude: locationLatLng['lat'],
          longitude: locationLatLng['lng'],
        );

        if (locationType == 'DROP') {
          context.read<LocationProvider>().updateDropLocation(model);
        } else {
          context.read<LocationProvider>().updatePickupLocation(model);
        }
      } else {
        throw Exception('خطأ في الاستجابة: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      throw Exception(e);
    }
  }
}
