part of 'workshop_search_bloc.dart';

@immutable
sealed class WorkshopSearchState extends Equatable {}

final class WorkshopSearchInitial extends WorkshopSearchState {
  @override
  List<Object?> get props => [];
}

final class WorkshopSearchFailure extends WorkshopSearchState {
  final String exception;

  WorkshopSearchFailure({required this.exception});
  @override
  List<Object?> get props => [exception];
}

final class WorkshopSearchSuccess extends WorkshopSearchState {
  final List<WorkshopModel> workshop;

  WorkshopSearchSuccess({required this.workshop});

  @override
  List<Object?> get props => [workshop];
}
