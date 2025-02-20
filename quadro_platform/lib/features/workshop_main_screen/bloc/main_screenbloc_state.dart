part of 'main_screenbloc_bloc.dart';

enum MainScreenStatus {
  initial,
  reqestloading,
  offerloading,
  success,
  failure,
  requestFailure,
  offerFailure
}

@immutable
class MainScreenState extends Equatable {
  final MainScreenStatus status;
  final List<MaintenanceRequestDomainModel>? offers;
  final List<MaintenanceRequestDomainModel>? requests;
  final Workshop? workshop;
  final String errorMessage;
  final int? requestNumber;

  const MainScreenState({
    this.requestNumber,
    this.errorMessage = "",
    this.status = MainScreenStatus.reqestloading,
    this.offers,
    this.requests,
    this.workshop,
  });

  MainScreenState copyWith({
    int? requestNumber,
    MainScreenStatus? status,
    List<MaintenanceRequestDomainModel>? offers,
    List<MaintenanceRequestDomainModel>? requests,
    Workshop? workshop,
    String? errorMessage,
  }) {
    return MainScreenState(
      requestNumber: requestNumber ?? this.requestNumber,
      status: status ?? this.status,
      offers: offers ?? this.offers,
      requests: requests ?? this.requests,
      workshop: workshop ?? this.workshop,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, offers, requests, workshop, errorMessage, requestNumber];
}
