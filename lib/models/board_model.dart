class BoardModel {
  int? id;
  String? title;
  List<Tasks>? tasks;

  BoardModel({this.id, this.title, this.tasks});

  BoardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((a) {
        tasks!.add(Tasks.fromJson(a));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  int? id;
  String? title;
  String? type;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? completedAt;
  String? duration;

  Tasks(
      {this.id,
      this.title,
      this.type,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.completedAt,
      this.duration});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    completedAt = json['completed_at'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['completed_at'] = this.completedAt;
    data['duration'] = this.duration;
    return data;
  }
}
