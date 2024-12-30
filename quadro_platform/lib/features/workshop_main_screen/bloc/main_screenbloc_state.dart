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
  final List<OffersDomainModel>? offers;
  final List<MaintenanceRequestDomainModel>? requests;
  final Workshop? workshop;
  final String errorMessage;

  const MainScreenState({
    this.errorMessage = "",
    this.status = MainScreenStatus.initial,
    this.offers,
    this.requests,
    this.workshop,
  });

  MainScreenState copyWith({
    MainScreenStatus? status,
    List<OffersDomainModel>? offers,
    List<MaintenanceRequestDomainModel>? requests,
    Workshop? workshop,
    String? errorMessage,
  }) {
    return MainScreenState(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      requests: requests ?? this.requests,
      workshop: workshop ?? this.workshop,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, offers, requests, workshop, errorMessage];
}
