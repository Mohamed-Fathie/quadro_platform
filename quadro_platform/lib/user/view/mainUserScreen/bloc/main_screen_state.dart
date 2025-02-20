part of 'main_screen_bloc.dart';

enum MainUserScreenStatus {
  loading,
  reqestloading,
  success,
  failure,
  requestFailure
}

@immutable
final class MainUserScreenState extends Equatable {
  final MainUserScreenStatus status;
  final List<MaintenanceRequestDomainModel>? requests;
  final String? errorMessage;
  final String? userName;
  final bool? thereIsOffer;

  const MainUserScreenState(
      {required this.status,
      this.requests,
      this.errorMessage,
      this.userName,
      this.thereIsOffer});
  MainUserScreenState copyWith({
    MainUserScreenStatus? status,
    List<MaintenanceRequestDomainModel>? requests,
    String? errorMessage,
    String? userName,
    bool? thereIsOffer,
  }) =>
      MainUserScreenState(
          thereIsOffer: thereIsOffer ?? this.thereIsOffer,
          status: status ?? this.status,
          requests: requests ?? this.requests,
          errorMessage: errorMessage ?? this.errorMessage,
          userName: userName ?? this.userName);

  @override
  List<Object?> get props =>
      [userName, errorMessage, status, requests, thereIsOffer];
}
