class VerifyOtpDataModel {
  int? userId;
  String? status;
  String? token;

  VerifyOtpDataModel({this.userId});

  VerifyOtpDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['token'] = this.token;
    return data;
  }
}
