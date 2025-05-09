import '../../../../exports.dart';
import '../repo/profits_repo.dart';

part 'profits_state.dart';

class ProfitsCubit extends Cubit<ProfitsInsightState> {
  ProfitInsightRepo profitInsightRepo;
  ProfitsCubit(this.profitInsightRepo) : super(ProfitsInsightInitial());

  List<dynamic> dataList = [];

  Future<void> getProfitInsights(String url, var data) async {
    try {
      emit(ProfitsInsightLoading());

      ResponseModel res = await profitInsightRepo.getProfitInsights(url, data);

      if (res.isSuccess) {

        dataList.add(res.response);
        emit(ProfitsInsightLoaded(data: dataList));
      } else {
        emit(ProfitsInsightError(message: res.response.toString()));
      }
    } catch (e) {
      emit(ProfitsInsightError(message: e.toString()));
    }
  }
}
