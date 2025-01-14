// ignore_for_file: constant_identifier_names

//request => pending ,sent => offer.pending ,
enum MaitenanceRequestStatus {
  pending, //1
  offerSent, //2
  rejected,
}

// request type either from vehicle owner or workshop owner
enum RequestType {
  workshop_id,
  vehicle_owner_id,
}
