class Todo {
  int? id;
  String? title;
  DateTime? alarmDateTime;
  int? todoStatus;
  int? gradientColorIndex;
  String? text1;
  int? text1Status;
  String? text2;
  int? text2Status;
  String? text3;
  int? text3Status;

  Todo({
    this.id,
    this.title,
    this.alarmDateTime,
    this.todoStatus,
    this.gradientColorIndex,
    this.text1,
    this.text1Status,
    this.text2,
    this.text2Status,
    this.text3,
    this.text3Status,
  });

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        todoStatus: json["todoStatus"],
        gradientColorIndex: json["gradientColorIndex"],
        text1: json["text1"],
        text1Status: json["text1Status"],
        text2: json["text2"],
        text2Status: json["text2Status"],
        text3: json["text3"],
        text3Status: json["text3Status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime!.toIso8601String(),
        "todoStatus": todoStatus,
        "gradientColorIndex": gradientColorIndex,
        "text1": text1,
        "text1Status": text1Status,
        "text2": text2,
        "text2Status": text2Status,
        "text3": text3,
        "text3Status": text3Status,
      };
}
