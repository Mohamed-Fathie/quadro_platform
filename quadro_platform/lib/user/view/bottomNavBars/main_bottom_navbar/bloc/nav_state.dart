import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../features/workshop_main_screen/models/maintenance_request_data_model.dart';

@immutable
final class NavState extends Equatable {
  final List<MaintenanceRequestDomainModel>? requests;

  final bool? thereIsOffer;

  const NavState({this.requests, this.thereIsOffer});
  NavState copyWith({
    List<MaintenanceRequestDomainModel>? requests,
    bool? thereIsOffer,
  }) =>
      NavState(
        thereIsOffer: thereIsOffer ?? this.thereIsOffer,
        requests: requests ?? this.requests,
      );

  @override
  List<Object?> get props => [requests, thereIsOffer];
}
