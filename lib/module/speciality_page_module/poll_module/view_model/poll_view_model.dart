import 'package:Coretext/module/article_module/model/article_data_model.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/model/poll_anaylicts_data_model.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/model/poll_data_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../../utils/WebService/end_points_constant.dart';

class PollViewModel extends GetxController {
  Rx<APIBaseModel<List<PollDataModel?>?>?> pollDataModel =
      RxNullable<APIBaseModel<List<PollDataModel?>?>?>().setNull();
  Rx<APIBaseModel<List<ArticleDataModel?>?>?> pollByIdDataModel =
      RxNullable<APIBaseModel<List<ArticleDataModel?>?>?>().setNull();
  Rx<APIBaseModel<PollDataModel?>?> pollAnswer =
      RxNullable<APIBaseModel<PollDataModel?>?>().setNull();

  Future<APIBaseModel<List<PollDataModel?>?>?> getPollList() async {
    pollDataModel.value = await APIService.getDataFromServerWithoutErrorModel<
        List<PollDataModel?>?>(
      endPoint: pollList,
      create: (dynamic json) {
        try {
          return (json as List).map((e) => PollDataModel.fromJson(e)).toList();
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    );
    return pollDataModel.value;
  }

  Future<APIBaseModel<List<ArticleDataModel?>?>?> getPollByIdList(
      int pollid) async {
    pollByIdDataModel.value = await APIService
        .getDataFromServerWithoutErrorModel<List<ArticleDataModel?>?>(
      endPoint: pollById(pollId: pollid),
      create: (dynamic json) {
        try {
          return (json as List)
              .map((e) => ArticleDataModel.fromJson(e))
              .toList();
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    );
    return pollByIdDataModel.value;
  }

  Future<APIBaseModel<PollDataModel?>?>? pollSelectedOpt(
      {int? selectedAnswer, int? pollId, String? selectedAnswerByPoll}) async {
    var body = {
      "poll_id": pollId,
      "user_id":
          "${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? ""}",
      "selected_option": selectedAnswer == 0 || selectedAnswer == null
          ? selectedAnswerByPoll
          : selectedAnswer,
    };
    print('Request Body: $body');

    pollAnswer.value = await APIService.postDataToServer(
        endPoint: pollSelectedOption,
        body: body,
        create: (dynamic json) {
          return PollDataModel.fromJson(json);
        });
    return pollAnswer.value;
  }
}
