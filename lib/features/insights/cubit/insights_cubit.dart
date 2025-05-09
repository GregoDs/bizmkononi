import 'package:biz_mkononi/features/insights/repo/insights_repo.dart';

import '../../../exports.dart';

part 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsRepo insightsRepo;
  InsightsCubit(this.insightsRepo) : super(InsightsInitial());

  List<dynamic> dataList = [];

  Future<void> getInsights(String url, var data) async {
    try {
      emit(InsightsLoading());

      ResponseModel res = await insightsRepo.getInsights(url, data);
      
      
      if (res.isSuccess) {
        
        dataList.add(res.response);
        emit(InsightsLoaded(data: dataList));
      } else {
        emit(InsightsError(message: res.response.toString()));
      }
    } catch (e) {
      emit(InsightsError(message: e.toString()));
    }
  }
}
