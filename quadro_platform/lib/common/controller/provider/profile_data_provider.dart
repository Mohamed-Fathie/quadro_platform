import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/constants/constants.dart';

class ProfileDataProvider extends ChangeNotifier {
  ProfileDataModel? profileData;

  Future<void> getProfileData() async {
    profileData =
        await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
            auth.currentUser!.uid);
    log(profileData!.toMap().toString());
    notifyListeners();
  }
}
