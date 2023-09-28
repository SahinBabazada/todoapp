class Todo {
  String id;
  String description;
  bool isCompleted;

  Todo({
    required this.id,
    required this.description,
    required this.isCompleted,
  });

  Todo copyWith(
      {String? id, String? description, DateTime? date, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": description,
        "completed": isCompleted,
      };
}
