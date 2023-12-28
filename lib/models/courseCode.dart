class DetailAttendance {
  final int id;
  final String studentCode;
  final int attendanceSheetId;
  final bool status;
  final DateTime createTime;
  final DateTime updateTime;
  final String courseCode; // Trường mới

  DetailAttendance({
    required this.id,
    required this.studentCode,
    required this.attendanceSheetId,
    required this.status,
    required this.createTime,
    required this.updateTime,
    required this.courseCode,
  });

  factory DetailAttendance.fromJson(Map<String, dynamic> json) {
    return DetailAttendance(
      id: json['id'] as int,
      studentCode: json['studentCode'] as String,
      attendanceSheetId: json['attendanceSheetId'] as int,
      status: json['status'] as bool,
      createTime: DateTime.parse(json['createTime'] as String),
      updateTime: DateTime.parse(json['updateTime'] as String),
      courseCode: json['courseCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentCode': studentCode,
      'attendanceSheetId': attendanceSheetId,
      'status': status,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
      'courseCode': courseCode,
    };
  }

// Bổ sung logic xử lý khác nếu cần
}
