part of 'details_cubit.dart';

@immutable
final class RequestDetailsState extends Equatable {
  final bool canMarkInProgress;
  final bool canRateService;
  final bool canRespond;
  final bool canMarkCompleted;
  final String? offerStatus;

  const RequestDetailsState({
    this.offerStatus,
    required this.canMarkCompleted,
    required this.canMarkInProgress,
    required this.canRateService,
    required this.canRespond,
  });
  RequestDetailsState copyWith({
    bool? canRateService,
    bool? canMarkInProgress,
    bool? canRespond,
    bool? canMarkCompleted,
    String? offerStatus,
  }) {
    return RequestDetailsState(
      offerStatus: offerStatus ?? this.offerStatus,
      canMarkCompleted: canMarkCompleted ?? this.canMarkCompleted,
      canRateService: canRateService ?? this.canRateService,
      canMarkInProgress: canMarkInProgress ?? this.canMarkInProgress,
      canRespond: canRespond ?? this.canRespond,
    );
  }

  @override
  List<Object?> get props => [
        canMarkInProgress,
        canRateService,
        canRespond,
        canMarkCompleted,
        offerStatus
      ];
}
