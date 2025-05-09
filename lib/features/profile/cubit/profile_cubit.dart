import 'package:biz_mkononi/features/profile/repo/profile_repo.dart';


import '../../../exports.dart';
import '../models/profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      ProfileModel? profileModel = await profileRepo.getProfile();
      if (profileModel != null) {
        emit(ProfileLoaded(profileModel: profileModel));
      } else {
        emit(ProfileError(message: 'No Profile Found'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfile(var data) async {
    emit(ProfileLoading());
    try {
      ResponseModel responseModel = await profileRepo.editProfile(data);
      if (responseModel.isSuccess) {
        emit(ProfileEdit());
      } else {
        emit(ProfileError(message: 'No Profile Found'));
      }
    } catch (e) {
      emit(ProfileError(message: 'Oops an error occurred Please try again...'));
    }
  }
}
