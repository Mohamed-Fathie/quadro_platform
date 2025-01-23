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
  final List<MaintenanceRequestDomainModel> requests;
  final String? errorMessage;
  final String? userName;

  const MainUserScreenState(
      {required this.status,
      required this.requests,
      this.errorMessage,
      this.userName});
  MainUserScreenState copyWith({
    MainUserScreenStatus? status,
    List<MaintenanceRequestDomainModel>? requests,
    String? errorMessage,
    String? userName,
  }) =>
      MainUserScreenState(
          status: status ?? this.status,
          requests: requests ?? this.requests,
          errorMessage: errorMessage ?? this.errorMessage,
          userName: userName ?? this.userName);

  @override
  List<Object?> get props => [userName, errorMessage, status, requests];
}
