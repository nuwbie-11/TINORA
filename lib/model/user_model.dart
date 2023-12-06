class UserModel {
  final int? id;
  final String userName;
  final String password;

  UserModel({this.id, required this.userName, required this.password});

  factory UserModel.fromJson(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map['id'],
      userName: map['username'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'userName': userName, 'password': password};
  }
}
