part of 'workshop_profile_cubit.dart';

enum WorkshopProfileStatus {
  loading,
  success,
  failure,
  fetchreviewloading,
  fetchreviewsuccess,
  sendingLoading,
  logout,
}

@immutable
final class WorkshopProfileState extends Equatable {
  final Map<String, dynamic>? reviewInfo;
  final List<ReviewDomainModel>? reviewslist;
  final WorkshopProfileStatus status;
  final String? errorMessage;
  final Map<String, String?> commentErrorMessages;
  final Workshop? workshop;

  const WorkshopProfileState({
    required this.commentErrorMessages,
    this.reviewInfo,
    this.reviewslist,
    required this.status,
    this.workshop,
    this.errorMessage,
  });
  WorkshopProfileState copyWith({
    Map<String, dynamic>? reviewInfo,
    List<ReviewDomainModel>? reviewslist,
    String? errorMessage,
    WorkshopProfileStatus? status,
    Workshop? workshop,
    Map<String, String?>? commentErrorMessages,
  }) =>
      WorkshopProfileState(
        commentErrorMessages: commentErrorMessages ?? this.commentErrorMessages,
        workshop: workshop ?? this.workshop,
        reviewInfo: reviewInfo ?? this.reviewInfo,
        reviewslist: reviewslist ?? this.reviewslist,
        status: status ?? this.status,
      );
  @override
  List<Object?> get props => [
        reviewInfo,
        reviewslist,
        status,
        errorMessage,
        workshop,
        commentErrorMessages
      ];
}
