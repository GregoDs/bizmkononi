

import '../../../exports.dart';

part 'businesses_state.dart';

class BusinessesCubit extends Cubit<BusinessesState> {
  BusinessesRepo businessesRepo; 
  BusinessesCubit(this.businessesRepo) : super(BusinessesInitial());

  Future<void> getBusinesses() async {
    try {
      emit(BusinessesLoading());
      final businessesModel = await businessesRepo.getBusinessses();
      if (businessesModel!.rows!.isEmpty) {
        emit(BusinessesLoaded(data: const []));
      } else {
        emit(BusinessesLoaded(data: businessesModel.rows!.reversed.toList()));
      }
    } catch (e) {
      emit(BusinessesError(message: e.toString()));
    }
  }

  Future<void> getSingleBusiness(String id) async {
    try {
      emit(BusinessesLoading());
      final businessDetailModel = await businessesRepo.getSingleBusiness(id);
      if(businessDetailModel == null){
        emit(BusinessesError(message: 'No Item retrieved'));
      }else{
        emit(BusinessDetailLoaded(data: businessDetailModel));
      }
      
    } catch (e) {
      emit(BusinessesError(message: e.toString()));
    }
  }

  Future<void> addBusiness(var data,) async {
    try {
      emit(BusinessesLoading());
      ResponseModel res = await businessesRepo.addBusiness(data,);
      if (res.isSuccess) {
        emit(BusinessesAdded());
      } else {
        emit(BusinessesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(BusinessesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editBusiness(
      String id, var data,) async {
    try {
      emit(BusinessesLoading());
      ResponseModel res =
          await businessesRepo.editBusiness(id, data,);
      if (res.isSuccess) {
        emit(BusinessesAdded());
      } else {
        emit(BusinessesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(BusinessesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      emit(BusinessesLoading());
      ResponseModel res = await businessesRepo.deleteBusiness(id);
      if (res.isSuccess) {
        emit(BusinessesDeleted());
      } else {
        emit(BusinessesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(BusinessesError(message: e.toString()));
    }
  }
}
