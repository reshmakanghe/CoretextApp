class UserDataModel {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? role;
  String? state;
  int? isDoctor;
  String? speciality;
  int? isMobileVerify;
  int? isEmailVerify;
  String? emailOtp;
  String? createdAt;
  String? updatedAt;
  int? updatedBy;
  String? status;
  String? fcmToken;
  int? isDelete;
  int? articlesViewed;
  int? articlesShared;
  int? articlesLikes;
  int? pollsParticipated;
  List<UserInterest>? userInterest;

  UserDataModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.role,
      this.state,
      this.isDoctor,
      this.speciality,
      this.isMobileVerify,
      this.isEmailVerify,
      this.emailOtp,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      this.status,
      this.fcmToken,
      this.isDelete,
      this.articlesViewed,
      this.articlesShared,
      this.articlesLikes,
      this.pollsParticipated,
      this.userInterest});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
    state = json['state'];
    isDoctor = json['is_doctor'];
    speciality = json['speciality'];
    isMobileVerify = json['is_mobile_verify'];
    isEmailVerify = json['is_email_verify'];
    emailOtp = json['email_otp'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    status = json['status'];
    fcmToken = json['fcm_token'];
    isDelete = json['is_delete'];
    articlesViewed = json['articles_viewed'];
    articlesShared = json['articles_shared'];
    articlesLikes = json['articles_likes'];
    pollsParticipated = json['polls_participated'];
    if (json['user_interest'] != null) {
      userInterest = <UserInterest>[];
      json['user_interest'].forEach((v) {
        userInterest!.add(new UserInterest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    data['state'] = this.state;
    data['is_doctor'] = this.isDoctor;
    data['speciality'] = this.speciality;
    data['is_mobile_verify'] = this.isMobileVerify;
    data['is_email_verify'] = this.isEmailVerify;
    data['email_otp'] = this.emailOtp;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['status'] = this.status;
    data['fcm_token'] = this.fcmToken;
    data['is_delete'] = this.isDelete;
    data['articles_viewed'] = this.articlesViewed;
    data['articles_shared'] = this.articlesShared;
    data['articles_likes'] = this.articlesLikes;
    data['polls_participated'] = this.pollsParticipated;
    if (this.userInterest != null) {
      data['user_interest'] =
          this.userInterest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserInterest {
  int? catId;
  String? catName;

  UserInterest({this.catId, this.catName});

  UserInterest.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    return data;
  }
}