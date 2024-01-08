class Alarm {
  int? id;
  String? title;
  DateTime? alarmDateTime;
  int? status;
  int? gradientColorIndex;

  Alarm(
      {this.id,
      this.title,
      this.alarmDateTime,
      this.status,
      this.gradientColorIndex});

  factory Alarm.fromMap(Map<String, dynamic> json) => Alarm(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        status: json["status"],
        gradientColorIndex: json["gradientColorIndex"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime!.toIso8601String(),
        "status": status,
        "gradientColorIndex": gradientColorIndex,
      };
}
