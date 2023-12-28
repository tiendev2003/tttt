class AttendanceSheet {
  final String courseId;
  final DateTime teachDate;
  final DateTime startTime;
  final DateTime endTime;
  final String lessonContent;
  final DateTime date;
  final String topic;
  final String course;


  AttendanceSheet({
    required this.courseId,
    required this.teachDate,
    required this.startTime,
    required this.endTime,
    required this.lessonContent,
    required this.date,
    required this.topic,
    required this.course,
  });
}

void main() {
  AttendanceSheet myAttendanceSheet = AttendanceSheet(
      courseId: 'Math101',
    teachDate: DateTime(2023, 12, 15),
    startTime: DateTime(2023, 12, 15, 9, 0),
    endTime: DateTime(2023, 12, 15, 11, 0),
    lessonContent: 'Introduction to Mathematics',
    date: DateTime.now(),
    topic: 'Your topic here',
    course : 'Danh Sach'

  );
}
