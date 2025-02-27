class PollAnalyticsDataModel {
  String? itemType;
  int? id;
  // Null? type;
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
  int? totalVotes;
  List<Votes>? votes;

  PollAnalyticsDataModel(
      {this.itemType,
      this.id,
      // this.type,
      this.title,
      this.description,
      this.imgUrl,
      this.externalUrl,
      this.status,
      this.createdAt,
      this.question,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.selectedOption,
      this.totalVotes,
      this.votes});

  PollAnalyticsDataModel.fromJson(Map<String, dynamic> json) {
    itemType = json['item_type'];
    id = json['id'];
    // type = json['type'];
    title = json['title'];
    description = json['description'];
    imgUrl = json['img_url'];
    externalUrl = json['external_url'];
    status = json['status'];
    createdAt = json['created_at'];
    question = json['question'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    totalVotes = json['total_votes'];
    selectedOption = json['selected_option'];
    if (json['votes'] != null) {
      votes = <Votes>[];
      json['votes'].forEach((v) {
        votes!.add(new Votes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_type'] = this.itemType;
    data['id'] = this.id;
    // data['type'] = this.type;
    data['title'] = this.title;
    data['description'] = this.description;
    data['img_url'] = this.imgUrl;
    data['external_url'] = this.externalUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['question'] = this.question;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['option3'] = this.option3;
    data['option4'] = this.option4;
    data['total_votes'] = this.totalVotes;
    data['selected_option'] = this.selectedOption;
    if (this.votes != null) {
      data['votes'] = this.votes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Votes {
  int? votes;
  String? option;

  Votes({this.votes, this.option});

  Votes.fromJson(Map<String, dynamic> json) {
    votes = json['votes'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['votes'] = this.votes;
    data['option'] = this.option;
    return data;
  }
}