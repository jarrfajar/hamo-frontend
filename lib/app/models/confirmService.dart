class ConfirmService {
  int? id;
  String? invoice;
  int? serviceId;
  int? categoryId;
  int? userId;
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
  Service? service;
  Category? category;
  User? user;

  ConfirmService(
      {this.id,
      this.invoice,
      this.serviceId,
      this.categoryId,
      this.userId,
      this.date,
      this.time,
      this.hours,
      this.description,
      this.address,
      this.amount,
      this.status,
      this.confirm,
      this.createdAt,
      this.updatedAt,
      this.service,
      this.category,
      this.user});

  ConfirmService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoice = json['invoice'];
    serviceId = json['service_id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
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
    service = json['service'] != null ? new Service.fromJson(json['service']) : null;
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invoice'] = this.invoice;
    data['service_id'] = this.serviceId;
    data['category_id'] = this.categoryId;
    data['user_id'] = this.userId;
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
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Service {
  int? id;
  int? userId;
  String? image;
  String? title;
  String? categoryId;
  String? description;
  String? price;
  String? createdAt;
  String? updatedAt;

  Service(
      {this.id,
      this.userId,
      this.image,
      this.title,
      this.categoryId,
      this.description,
      this.price,
      this.createdAt,
      this.updatedAt});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    image = json['image'];
    title = json['title'];
    categoryId = json['category_id'];
    description = json['description'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? img;
  String? createdAt;
  String? updatedAt;

  Category({this.id, this.name, this.img, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  Profile? profile;
  List<Roles>? roles;

  User(
      {this.id, this.name, this.email, this.emailVerifiedAt, this.createdAt, this.updatedAt, this.profile, this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
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
