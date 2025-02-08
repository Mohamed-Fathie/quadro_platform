import 'package:flutter/material.dart';
import 'package:quadro_platform/common/modele/pickup&drop_location_model.dart';
import 'package:quadro_platform/common/modele/searched_address_model.dart';

class LocationProvider extends ChangeNotifier {
  List<SearchedAddressModel> searchedAddress = [];
  PickupAndDropLocationModel? dropLocation;
  PickupAndDropLocationModel? pickupLocation;

  nullifyDropLocation() {
    dropLocation = null;
    notifyListeners();
  }

  nullifyPickupLocation() {
    pickupLocation = null;
    notifyListeners();
  }

  updateSearchedAddress(List<SearchedAddressModel> newAddressList) {
    searchedAddress = newAddressList;
    notifyListeners();
  }

  emptySearchedAddressList() {
    searchedAddress = [];
    notifyListeners();
  }

  updateDropLocation(PickupAndDropLocationModel newAddress) {
    dropLocation = newAddress;
    notifyListeners();
  }

  updatePickupLocation(PickupAndDropLocationModel newAddress) {
    pickupLocation = newAddress;
    notifyListeners();
  }
}
