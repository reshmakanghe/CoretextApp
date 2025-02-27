class ArticleDataModel {
  String? itemType;
  int? id;
  String? type;
  String? title;
  String? description;
  String? imgUrl;
  String? externalUrl;
  String? status;
  String? createdAt;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? selectedOption;
  String? authorName;
  int? likes;
  int? isLike;
  int? isBookmark;
  int? totalVotes;
  int? button;
  String? buttonName;
  List<Votes>? votes;

  ArticleDataModel(
      {this.itemType,
      this.id,
      this.type,
      this.title,
      this.description,
      this.imgUrl,
      this.externalUrl,
      this.status,
      this.createdAt,
      this.likes,
      this.question,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.selectedOption,
      this.authorName,
      this.isLike,
      this.isBookmark,
      this.totalVotes,
      this.button,
      this.buttonName,
      this.votes});

  ArticleDataModel.fromJson(Map<String, dynamic> json) {
    itemType = json['item_type'] ?? "";
    id = json['id'] ?? 0;
    type = json['type'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    imgUrl = json['img_url'] ?? "";
    externalUrl = json['external_url'] ?? "";
    authorName = json['author_name'] ?? "";
    status = json['status'] ?? "";
    createdAt = json['created_at'] ?? "";
    likes = json['likes'] ?? 0;
    isBookmark = json['is_bookmark'] ?? 0;
    isLike = json['is_like'] ?? 0;
    question = json['question'] ?? "";
    option1 = json['option1'] ?? "";
    option2 = json['option2'] ?? "";
    option3 = json['option3'] ?? "";
    option4 = json['option4'] ?? "";
    totalVotes = json['total_votes'] ?? 0;
    button = json['button'] ?? 0;
    buttonName = json['button_name'] ?? "";
    selectedOption = json['selected_option'] ?? "";
    if (json['votes'] != null) {
      votes = <Votes>[];
      json['votes'].forEach((v) {
        votes!.add(Votes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_type'] = this.itemType;
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['description'] = this.description;
    data['img_url'] = this.imgUrl;
    data['external_url'] = this.externalUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['author_name'] = this.authorName;
    data['likes'] = this.likes;
    data['is_bookmark'] = this.isBookmark;
    data['is_like'] = this.isLike;
    data['question'] = this.question;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['option3'] = this.option3;
    data['option4'] = this.option4;
    data['selected_option'] = this.selectedOption;
    data['total_votes'] = this.totalVotes;

    if (this.votes != null) {
      data['votes'] = this.votes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Votes {
  String? option;
  int? vote;

  Votes({this.option, this.vote});

  Votes.fromJson(Map<String, dynamic> json) {
    option = json['option'] ?? "";
    vote = json['votes'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option'] = this.option;
    data['votes'] = this.vote;
    return data;
  }
}



// class ArticleDataModel {
//   int? articleId;
//   String? type;
//   String? title;
//   String? description;
//   String? imgUrl;
//   String? status;
//   String? externalUrl;
//   String? createdAt;
//   String? updatedAt;
//   String? createdBy;
//   String? updatedBy;
//   String? authorName;
//   int? articleLiked;
//   int? articleShared;
//   int? articleViewed;
//   String? itemType;
//   List<CatId>? catId;

//   ArticleDataModel(
//       {this.articleId,
//       this.type,
//       this.title,
//       this.description,
//       this.imgUrl,
//       this.status,
//       this.externalUrl,
//       this.createdAt,
//       this.updatedAt,
//       this.createdBy,
//       this.updatedBy,
//       this.authorName,
//       this.itemType,
//       this.catId});

//   // Modified fromJson with additional null checks
//   ArticleDataModel.fromJson(Map<String, dynamic> json) {
//     articleId = json['item_id'] != null ? json['item_id'] as int : null;
//     type = json['type'] ?? "";
//     title = json['title'] ?? "";
//     description = json['description'] ?? "";
//     imgUrl = json['img_url'] ?? "";
//     status = json['status'] ?? "";
//     externalUrl = json['external_url'] ?? "";
//     createdAt = json['created_at'] ?? "";
//     updatedAt = json['updated_at'] ?? "";
//     createdBy = json['created_by'] ?? "";
//     updatedBy = json['updated_by'] ?? "";
//     authorName = json['author_name'] ?? "";
//     articleLiked = json['article_liked'] ?? 0;
//     articleShared = json['article_shared'] ?? 0;
//     itemType = json['item_type'];
//     articleViewed = json['article_viewd'] ?? 0;

//     // Safely handling the `cat_id` list, checking both existence and non-null values
//     if (json['cat_id'] != null && json['cat_id'] is List) {
//       catId = <CatId>[];
//       json['cat_id'].forEach((v) {
//         if (v != null && v is Map<String, dynamic>) {
//           catId!.add(CatId.fromJson(v)); // Only add valid CatId objects
//         }
//       });
//     } else {
//       catId = null; // Set to null if `cat_id` is not valid
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['item_id'] = articleId;
//     data['type'] = type;
//     data['title'] = title;
//     data['description'] = description;
//     data['img_url'] = imgUrl;
//     data['status'] = status;
//     data['external_url'] = externalUrl;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['created_by'] = createdBy;
//     data['updated_by'] = updatedBy;
//     data['author_name'] = authorName;
//     data['article_liked'] = articleLiked;
//     data['article_shared'] = articleShared;
//     data['article_viewd'] = articleViewed;
//     data['item_type'] = itemType;
//     if (catId != null) {
//       data['cat_id'] = catId!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class CatId {
//   int? catId;
//   String? imgUrl;
//   String? catName;

//   CatId({this.catId, this.imgUrl, this.catName});

//   // Modified fromJson with additional null checks
//   CatId.fromJson(Map<String, dynamic> json) {
//     catId = json['cat_id'] != null ? json['cat_id'] as int : null;
//     imgUrl = json['img_url'] ?? "";
//     catName = json['cat_name'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['cat_id'] = catId;
//     data['img_url'] = imgUrl;
//     data['cat_name'] = catName;
//     return data;
//   }
// }
