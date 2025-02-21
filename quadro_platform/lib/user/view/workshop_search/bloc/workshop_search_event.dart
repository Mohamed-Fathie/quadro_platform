part of 'workshop_search_bloc.dart';

@immutable
sealed class WorkshopSearchEvent {}

final class WorkshopFetched extends WorkshopSearchEvent {}
