class TasksModel {
  final int? id;
  final int createdAt;
  final int deadline;
  final String description;
  final int isImportant;

  TasksModel({
    this.id,
    required this.createdAt,
    required this.deadline,
    required this.description,
    this.isImportant = 0,
  });

  factory TasksModel.fromJson(Map<dynamic, dynamic> map) {
    return TasksModel(
      id: map['id'],
      description: map['description'],
      createdAt: map['createdAt'],
      deadline: map['deadline'],
      isImportant: map['isImportant'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'createdAt': createdAt,
      'deadline': deadline,
      'isImportant': isImportant,
    };
  }
}
