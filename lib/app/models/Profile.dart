class UserProfile {
  int? id;
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;
  Profile? profile;
  List<Roles>? roles;
  List<Transaction>? transaction;

  UserProfile(
      {this.id, this.name, this.email, this.createdAt, this.updatedAt, this.profile, this.roles, this.transaction});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Profile {
  int? id;
  int? userId;
  String? image;
  String? birthday;
  String? phone;
  String? gender;
  String? address;
  String? createdAt;
  String? updatedAt;

  Profile(
      {this.id,
      this.userId,
      this.image,
      this.birthday,
      this.phone,
      this.gender,
      this.address,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    image = json['image'];
    birthday = json['birthday'];
    phone = json['phone'];
    gender = json['gender'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['birthday'] = this.birthday;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles({this.id, this.name, this.guardName, this.createdAt, this.updatedAt, this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? modelId;
  int? roleId;
  String? modelType;

  Pivot({this.modelId, this.roleId, this.modelType});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    roleId = json['role_id'];
    modelType = json['model_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    data['model_type'] = this.modelType;
    return data;
  }
}

class Transaction {
  int? id;
  String? invoice;
  int? serviceId;
  int? categoryId;
  int? userId;
  int? penjualId;
  String? date;
  String? time;
  int? hours;
  String? description;
  String? address;
  String? amount;
  String? status;
  String? confirm;
  String? createdAt;
  String? updatedAt;

  Transaction(
      {this.id,
      this.invoice,
      this.serviceId,
      this.categoryId,
      this.userId,
      this.penjualId,
      this.date,
      this.time,
      this.hours,
      this.description,
      this.address,
      this.amount,
      this.status,
      this.confirm,
      this.createdAt,
      this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoice = json['invoice'];
    serviceId = json['service_id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    penjualId = json['penjual_id'];
    date = json['date'];
    time = json['time'];
    hours = json['hours'];
    description = json['description'];
    address = json['address'];
    amount = json['amount'];
    status = json['status'];
    confirm = json['confirm'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invoice'] = this.invoice;
    data['service_id'] = this.serviceId;
    data['category_id'] = this.categoryId;
    data['user_id'] = this.userId;
    data['penjual_id'] = this.penjualId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['hours'] = this.hours;
    data['description'] = this.description;
    data['address'] = this.address;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['confirm'] = this.confirm;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
