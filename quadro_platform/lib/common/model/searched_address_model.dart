import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SearchedAddressModel {
  String? mainName;
  String? secondaryName;
  String? placeID;
  SearchedAddressModel({
    this.mainName,
    this.secondaryName,
    this.placeID,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainName': mainName,
      'secondaryName': secondaryName,
      'placeID': placeID,
    };
  }

  factory SearchedAddressModel.fromMap(Map<String, dynamic> map) {
    return SearchedAddressModel(
      mainName: map['mainName'] != null ? map['mainName'] as String : null,
      secondaryName: map['secondaryName'] != null ? map['secondaryName'] as String : null,
      placeID: map['placeID'] != null ? map['placeID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchedAddressModel.fromJson(String source) => SearchedAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
