import '../../../exports.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> logIn(var data) async {
    emit(AuthLoading());
    ResponseModel response = await _authRepo.login(data);
    if (response.isSuccess) {
      emit(AuthLoaded(message: response.response));
    } else {
      emit(AuthError(message: response.response));
    }
    // try {
    //   ResponseModel response = await _authRepo.login(data);
    //   if (response.isSuccess) {
    //     emit(AuthLoaded(message: response.response));
    //   } else {
    //     emit(AuthError(message: response.response));
    //   }
    // } catch (e) {
    //   emit(AuthError(message: e.toString()));
    // }
  }

  Future<void> register(var data) async {
    emit(AuthLoading());
    ResponseModel response = await _authRepo.register(data);
    if (response.isSuccess) {
      emit(AuthLoaded(message: response.response));
    } else if (!response.isSuccess) {
      emit(AuthError(message: response.response));
    }
  }

  Future<void> resendCode(var data) async {
    emit(AuthLoading());
    ResponseModel response = await _authRepo.resendCode(data);
    if (response.isSuccess) {
      emit(AuthLoaded(message: response.response));
    } else if (!response.isSuccess) {
      emit(AuthError(message: response.response.toString()));
    }
  }

  Future<void> verifyCode(var data) async {
    emit(AuthLoading());
    ResponseModel response = await _authRepo.verifyCode(data);
    if (response.isSuccess) {
      emit(AuthLoaded(message: response.response));
    } else if (!response.isSuccess) {
      emit(AuthError(message: response.response.toString()));
    }
  }

  Future<void> forgotPassword(var data) async {
    emit(AuthLoading());
    ResponseModel response = await _authRepo.forgotPassword(data);
    if (response.isSuccess) {
      emit(AuthLoaded(message: response.response));
    } else if (!response.isSuccess) {
      emit(AuthError(message: response.response.toString()));
    }
  }

  Future<void> resetPassword(var data) async {
    emit(AuthLoading());
    ResponseModel response = await _authRepo.resetPassword(data);
    if (response.isSuccess) {
      emit(AuthLoaded(message: response.response));
    } else if (!response.isSuccess) {
      emit(AuthError(message: response.response.toString()));
    }
  }
}
