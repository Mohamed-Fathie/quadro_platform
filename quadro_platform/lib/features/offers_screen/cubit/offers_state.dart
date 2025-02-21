part of 'offers_cubit.dart';

@immutable
sealed class OffersState extends Equatable {
  final int index;

  const OffersState({required this.index});
  @override
  List<Object?> get props => [index];
}

final class OfferFetchloading extends OffersState {
  const OfferFetchloading({required super.index});

  @override
  List<Object?> get props => [];
}

final class OfferFetchAllSuccess extends OffersState {
  final List<MaintenanceRequestDomainModel> allOffers;

  const OfferFetchAllSuccess({required this.allOffers, required super.index});
  @override
  List<Object?> get props => [allOffers];
}

final class OfferFetchInprogressSuccess extends OffersState {
  final List<MaintenanceRequestDomainModel> inprogressOffers;

  const OfferFetchInprogressSuccess(
      {required this.inprogressOffers, required super.index});

  @override
  List<Object?> get props => [inprogressOffers];
}

final class OfferFetchPendingSuccess extends OffersState {
  final List<MaintenanceRequestDomainModel> pendingOffers;

  const OfferFetchPendingSuccess(
      {required this.pendingOffers, required super.index});

  @override
  List<Object?> get props => [pendingOffers];
}

final class OfferFetchAcceptedSuccess extends OffersState {
  final List<MaintenanceRequestDomainModel> acceptedOffers;

  const OfferFetchAcceptedSuccess(
      {required this.acceptedOffers, required super.index});

  @override
  List<Object?> get props => [acceptedOffers];
}

final class OfferFetchRejectedSuccess extends OffersState {
  final List<MaintenanceRequestDomainModel> rejectedOffers;

  const OfferFetchRejectedSuccess(
      {required this.rejectedOffers, required super.index});

  @override
  List<Object?> get props => [rejectedOffers];
}

final class OfferFetchCompletedSuccess extends OffersState {
  final List<MaintenanceRequestDomainModel> completed;

  const OfferFetchCompletedSuccess(
      {required this.completed, required super.index});

  @override
  List<Object?> get props => [completed];
}

final class OfferFetchFailure extends OffersState {
  final String error;

  const OfferFetchFailure({required this.error, required super.index});

  @override
  List<Object?> get props => [error];
}

final class RequestSuccess extends OffersState {
  final List<MaintenanceRequestDomainModel> requests;

  const RequestSuccess({required this.requests, required super.index});

  @override
  List<Object?> get props => [requests];
}
