class SignUpDataModel {
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? role;
  int? isDoctor;
  String? speciality;
  String? address;
  String? city;
  String? state;
  int? pincode;
  int? updatedBy;
  int? userId;
  String? fcmToken;
  String? status;
  int? isEmailVerify;
  String? gId;
  String? token;

  SignUpDataModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.role,
      this.isDoctor,
      this.speciality,
      this.address,
      this.city,
      this.state,
      this.pincode,
      this.updatedBy,
      this.userId,
      this.fcmToken,
      this.status,
      this.isEmailVerify,
      this.gId,
      this.token});

  SignUpDataModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
    isDoctor = json['is_doctor'];
    speciality = json['speciality'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    updatedBy = json['updated_by'];
    userId = json['user_id'];
    fcmToken = json['fcm_token'];
    status = json['status'];
    isEmailVerify = json['is_email_verify'];
    gId = json['g_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    data['is_doctor'] = this.isDoctor;
    data['speciality'] = this.speciality;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['updated_by'] = this.updatedBy;
    data['user_id'] = this.userId;
    data['fcm_token'] = this.fcmToken;
    data['status'] = this.status;
    data['is_email_verify'] = this.isEmailVerify;
    data['g_id'] = this.gId;
    data['token'] = this.token;
    return data;
  }
}
