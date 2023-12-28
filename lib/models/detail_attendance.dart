class DetailAttendance {
  final String studentId;
  String courseId;
  bool isPresent;
  DateTime updateTime;
  DateTime checkInTime;
  DateTime checkOutTime;
  final String studentName;
  // Adding studentName property


  DetailAttendance({
    required this.studentId,
    required this.courseId,
    required this.isPresent,
    required this.updateTime,
    required this.checkInTime,
    required this.checkOutTime,
    required this.studentName,
  });
}
