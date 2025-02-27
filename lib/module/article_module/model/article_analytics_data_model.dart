class ArticleAnalyticsDataModel {
  int? articleId;
  int? userId;
  String? type;
  int? adId;

  ArticleAnalyticsDataModel({this.articleId, this.userId, this.type});

  ArticleAnalyticsDataModel.fromJson(Map<String, dynamic> json) {
    articleId = json['article_id'];
    userId = json['user_id'];
    type = json['type'];
    adId = json['ad_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['article_id'] = this.articleId;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['ad_id'] = this.adId;
    return data;
  }
}
