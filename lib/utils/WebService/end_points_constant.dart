//Auth related end points
import 'package:Coretext/utils/initialization_services/singleton_service.dart';

String sendOTPEndPoint = "sendotp";
String verifyOtpEndPoint = "verify";
String signupEndPoint = "signup";
String loginEndPoint = "login";
String pollList = "batch";
String pollById({required int pollId}) => "batch?polls=true&poll_id=$pollId";
String pollSelectedOption = "poll-analytics";
String specialtyList = "categories?status=active";
String articleEndPoint = "articles";
String articleBatchEndPoint = "batch";
String articleDetailsEndPoint({required int articleID}) =>
    "articles?article_id=$articleID";
String articleByCatId({required int catID}) => "batch?category_ids=$catID";
String articleMyCatId({required List<int> catId}) => "batch?category_ids=$catId";
String bookMarkedArticle({required List<int> articleIds}) =>
    "batch?article_ids=$articleIds";
String mapCategory = "user_cat_mapping";
String userEndPoint({required int userId}) =>"users?user_id=$userId";
String updateUserProfile =
    "users/${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? ""}";
String articleAnalyticsEndPoint = "article_analytics";
String adAnalyticsEndpoint = "ad_analytics";
String mySpecialtyCatById =
    "categories?user_id=${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? ""}";
