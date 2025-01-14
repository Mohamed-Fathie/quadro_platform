part of 'workshop_offers_cubit.dart';

@immutable
sealed class WorkshopOffersState extends Equatable {
  final int index;

  const WorkshopOffersState({required this.index});
  @override
  List<Object?> get props => [index];
}

final class WorkshopOfferFetchloading extends WorkshopOffersState {
  const WorkshopOfferFetchloading({required super.index});

  @override
  List<Object?> get props => [];
}

final class WorkshopOfferFetchAllSuccess extends WorkshopOffersState {
  final List<MaintenanceRequestDomainModel> allOffers;

  const WorkshopOfferFetchAllSuccess(
      {required this.allOffers, required super.index});
  @override
  List<Object?> get props => [allOffers];
}

final class WorkshopOfferFetchInprogressSuccess extends WorkshopOffersState {
  final List<MaintenanceRequestDomainModel> inprogressOffers;

  const WorkshopOfferFetchInprogressSuccess(
      {required this.inprogressOffers, required super.index});

  @override
  List<Object?> get props => [inprogressOffers];
}

final class WorkshopOfferFetchPendingSuccess extends WorkshopOffersState {
  final List<MaintenanceRequestDomainModel> pendingOffers;

  const WorkshopOfferFetchPendingSuccess(
      {required this.pendingOffers, required super.index});

  @override
  List<Object?> get props => [pendingOffers];
}

final class WorkshopOfferFetchFailure extends WorkshopOffersState {
  final String error;

  const WorkshopOfferFetchFailure({required this.error, required super.index});

  @override
  List<Object?> get props => [error];
}

final class WorkshopRequestSuccess extends WorkshopOffersState {
  final List<MaintenanceRequestDomainModel> requests;

  const WorkshopRequestSuccess({required this.requests, required super.index});

  @override
  List<Object?> get props => [requests];
}
