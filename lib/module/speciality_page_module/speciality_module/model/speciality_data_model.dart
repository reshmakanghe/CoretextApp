class SpecialityDataModel {
  int? catId;
  String? catName;
  String? imgUrl;
  String? status;
  int? del;
  int? articleCount;
  int? pollCount;

  SpecialityDataModel(
      {this.catId,
      this.catName,
      this.imgUrl,
      this.status,
      this.del,
      this.articleCount,
      this.pollCount});

  SpecialityDataModel.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
    imgUrl = json['img_url'];
    status = json['status'];
    del = json['del'];
    articleCount = json['article_count'];
    pollCount = json['poll_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    data['img_url'] = this.imgUrl;
    data['status'] = this.status;
    data['del'] = this.del;
    data['article_count'] = this.articleCount;
    data['poll_count'] = this.pollCount;
    return data;
  }
}

class SelectedSpeciality {
  final int catId;
  final String catName;

  SelectedSpeciality(this.catId, this.catName);
}
