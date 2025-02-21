part of 'registeration_cubit.dart';

@immutable
sealed class RegisterationState extends Equatable {}

final class RegisterationInitial extends RegisterationState {
  @override
  List<Object?> get props => [];
}

final class RoleSelected extends RegisterationState {
  final UserRole selectedRole;
  RoleSelected(this.selectedRole);

  @override
  List<Object?> get props => [selectedRole];
}

final class RegisterationLoading extends RegisterationState {
  @override
  List<Object?> get props => [];
}

final class RoleSelectedSuccess extends RegisterationState {
  final UserRole selectedUserRole;

  RoleSelectedSuccess({required this.selectedUserRole});
  @override
  List<Object?> get props => [selectedUserRole];
}
