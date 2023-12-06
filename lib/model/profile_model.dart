class ProfileModel {
  final int? id;
  final int userId;
  final String name;
  final int level;
  final double experience;

  ProfileModel(
      {required this.userId,
      required this.name,
      required this.level,
      required this.experience,
      this.id});

  factory ProfileModel.fromJson(Map<dynamic, dynamic> map) {
    return ProfileModel(
        id: map['id'],
        userId: map['userId'],
        name: map['name'],
        level: map['level'],
        experience: map['experience']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'level': level,
      'experience': experience,
    };
  }
}
