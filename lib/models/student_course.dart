class StudentCourse {
  int? id;
  String? studentCode;
  int? courseId;
  bool? extraSheet;
  bool? status;
  DateTime? createTime;
  DateTime? updateTime;

  StudentCourse({
    this.id,
    this.studentCode,
    this.courseId,
    this.extraSheet,
    this.status,
    this.createTime,
    this.updateTime,
  });

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    return StudentCourse(
      id: json['id'],
      studentCode: json['studentCode'],
      courseId: json['courseId'],
      extraSheet: json['extraSheet'],
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentCode': studentCode,
      'courseId': courseId,
      'extraSheet': extraSheet,
      'status': status,
      'createTime': createTime.toString(),
      'updateTime': updateTime.toString(),
    };
  }
}
