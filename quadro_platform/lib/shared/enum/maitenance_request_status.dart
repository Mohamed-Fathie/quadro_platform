// ignore_for_file: constant_identifier_names

enum MaitenanceRequestStatus {
  pending,
  underMaintenance,
  completed,
  rejected,
}

// request type either from vehicle owner or workshop owner
enum RequestType {
  workshop_id,
  vehicle_owner_id,
}
