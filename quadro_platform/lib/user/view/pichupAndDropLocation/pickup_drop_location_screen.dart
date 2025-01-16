import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/provider/location_provider.dart';
import 'package:quadro_platform/common/controller/services/location_services.dart';
import 'package:quadro_platform/common/model/pickup&drop_location_model.dart';
import 'package:quadro_platform/common/model/searched_address_model.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:sizer/sizer.dart';

class PickupAndDropLocationScreen extends StatefulWidget {
  PickupAndDropLocationScreen({super.key});

  @override
  State<PickupAndDropLocationScreen> createState() =>
      _PickupAndDropLocationScreenState();
}

class _PickupAndDropLocationScreenState
    extends State<PickupAndDropLocationScreen> {
  TextEditingController pickupLocationController = TextEditingController();

  TextEditingController dropLocationController = TextEditingController();

  getCurrentAddress() async {
    LatLng currentLocation = await LocationServices.getCurrentLocation();
    if (mounted) {
      PickupAndDropLocationModel currentLocationAddress =
          await LocationServices.getAddressFromLatLng(
              position: currentLocation, context: context);
      pickupLocationController.text = currentLocationAddress.name!;
    }
    ;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100.w, 23.3.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    size: 22.5.sp,
                    Icons.arrow_back,
                    color: black,
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 3.h,
                              color: black,
                            ),
                            Expanded(
                              child: Container(
                                width: 0.5.w,
                                color: black,
                                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              ),
                            ),
                            Icon(
                              Icons.square,
                              size: 2.h,
                              color: black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.right,
                              controller: pickupLocationController,
                              cursorColor: black,
                              style: AppTextStyles.Mbody18Bold,
                              onChanged: (value) {
                                LocationServices.getSerchedAddress(
                                    placeName: value, context: context);
                              },
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    pickupLocationController.clear();
                                  },
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: teal,
                                  ),
                                ),
                                filled: true,
                                fillColor: txtfld,
                                hintText: "من",
                                hintStyle: AppTextStyles.Mbody18Bold,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: teal,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.right,
                              controller: dropLocationController,
                              onChanged: (value) {
                                LocationServices.getSerchedAddress(
                                  placeName: value,
                                  context: context,
                                );
                              },
                              cursorColor: black,
                              style: AppTextStyles.Mbody18Bold,
                              decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      dropLocationController.clear();
                                    },
                                    child: Icon(
                                      CupertinoIcons.xmark,
                                      color: teal,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: txtfld,
                                  hintText: "الى",
                                  hintStyle: AppTextStyles.Mheading20Bold,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: teal,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: white,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  if (locationProvider.searchedAddress.isEmpty) {
                    return Center(
                      child: Text(
                        'ابحث عن عنوان وجهتك',
                        style: AppTextStyles.Mheading20Bold,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: locationProvider.searchedAddress.length,
                        itemBuilder: (context, index) {
                          SearchedAddressModel currentAddress =
                              locationProvider.searchedAddress[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: greyShade3,
                              radius: 2.7.h,
                              child: Icon(
                                Icons.location_on,
                                color: teal,
                              ),
                            ),
                            title: Text(
                              currentAddress.mainName ?? "اسم غير متوفر",
                              style: AppTextStyles.Mbody18Bold,
                            ),
                            subtitle: Text(
                              currentAddress.secondaryName ?? "عنوان غير متوفر",
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
