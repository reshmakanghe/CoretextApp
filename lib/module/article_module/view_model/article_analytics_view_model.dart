import 'package:Coretext/module/article_module/model/article_analytics_data_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/WebService/end_points_constant.dart';

import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:get/get.dart';

class ArticleAnalyticsViewModel extends GetxController {
  Rx<APIBaseModel<ArticleAnalyticsDataModel?>?>? articleAnalyticsDataModel =
      RxNullable<APIBaseModel<ArticleAnalyticsDataModel?>?>().setNull();

//api for like share count of articles
  Future<APIBaseModel<ArticleAnalyticsDataModel?>?>?
      articleAnalyticsForLikeShareCount({int? articleId, String? type}) async {
    articleAnalyticsDataModel?.value =
        await APIService.postDataToServer<ArticleAnalyticsDataModel?>(
            endPoint: articleAnalyticsEndPoint,
            body: {
              "article_id": articleId,
              "user_id": CoreTextAppGlobal.instance.loginViewModel
                      .loginDataModel?.value?.responseBody?.userId ??
                  0,
              "type": type // "view" || "click" || "like"
            },
            create: (dynamic json) {
              if (json != null && json is Map<String, dynamic>) {
                return ArticleAnalyticsDataModel.fromJson(json);
              }
              return null;
            });
    return articleAnalyticsDataModel?.value;
  }

  //api for like share count of articles
  Future<APIBaseModel<ArticleAnalyticsDataModel?>?>? adAnalytics(
      {int? adId, String? type}) async {
    articleAnalyticsDataModel?.value =
        await APIService.postDataToServer<ArticleAnalyticsDataModel?>(
            endPoint: adAnalyticsEndpoint,
            body: {
              "ad_id": adId,
              "user_id": CoreTextAppGlobal.instance.loginViewModel
                      .loginDataModel?.value?.responseBody?.userId ??
                  0,
              "type": type // "view" || "click" || "like"
            },
            create: (dynamic json) {
              if (json != null && json is Map<String, dynamic>) {
                return ArticleAnalyticsDataModel.fromJson(json);
              }
              return null;
            });
    return articleAnalyticsDataModel?.value;
  }
}
