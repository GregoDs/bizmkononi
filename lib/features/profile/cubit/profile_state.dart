part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileModel profileModel;

  ProfileLoaded({required this.profileModel});
}

final class ProfileEdit extends ProfileState {}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
