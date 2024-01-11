class Todo {
  int? id;
  String? title;
  DateTime? alarmDateTime;
  int? todoStatus;
  DateTime? reminderDateTime;
  String? text1;
  int? text1Status;
  String? text2;
  int? text2Status;
  String? text3;
  int? text3Status;
  int? reminderAlarmId;
  int? alarmDateTimeId;

  Todo(
      {this.id,
      this.title,
      this.alarmDateTime,
      this.todoStatus,
      this.reminderDateTime,
      this.text1,
      this.text1Status,
      this.text2,
      this.text2Status,
      this.text3,
      this.text3Status,
      this.reminderAlarmId,
      this.alarmDateTimeId});

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        todoStatus: json["todoStatus"],
        reminderDateTime: DateTime.parse(json["reminderDateTime"]),
        text1: json["text1"],
        text1Status: json["text1Status"],
        text2: json["text2"],
        text2Status: json["text2Status"],
        text3: json["text3"],
        text3Status: json["text3Status"],
        reminderAlarmId: json["reminderAlarmId"],
        alarmDateTimeId: json["alarmDateTimeId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime!.toIso8601String(),
        "todoStatus": todoStatus,
        "reminderDateTime": reminderDateTime!.toIso8601String(),
        "text1": text1,
        "text1Status": text1Status,
        "text2": text2,
        "text2Status": text2Status,
        "text3": text3,
        "text3Status": text3Status,
        "reminderAlarmId": reminderAlarmId,
        "alarmDateTimeId": alarmDateTimeId,
      };
}
