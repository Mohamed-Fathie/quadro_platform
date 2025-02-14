part of 'details_cubit.dart';

@immutable
final class RequestDetailsState extends Equatable {
  final bool canMarkInProgress;
  final bool canRateService;
  final bool canRespond;

  const RequestDetailsState({
    required this.canMarkInProgress,
    required this.canRateService,
    required this.canRespond,
  });
  RequestDetailsState copyWith({
    bool? canRateService,
    bool? canMarkInProgress,
    bool? canRespond,
  }) {
    return RequestDetailsState(
      canRateService: canRateService ?? this.canRateService,
      canMarkInProgress: canMarkInProgress ?? this.canMarkInProgress,
      canRespond: canRespond ?? this.canRespond,
    );
  }

  @override
  List<Object?> get props => [canMarkInProgress, canRateService, canRespond];
}
