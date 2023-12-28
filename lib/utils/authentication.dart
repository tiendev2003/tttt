import 'package:flutter/material.dart';
import '/screens/professor_screen.dart' as ProfessorScreenPage;
import '/models/attendance_sheet.dart';
import '/models/detail_attendance.dart';

void main() {
  AttendanceSheet attendanceSheet = AttendanceSheet(
    courseId: 'Math101',
    teachDate: DateTime(2023, 12, 15),
    startTime: DateTime(2023, 12, 15, 9, 0),
    endTime: DateTime(2023, 12, 15, 11, 0),
    lessonContent: 'Introduction to Mathematics',
    date: DateTime.now(),
    topic: 'Your topic here',
    course: 'Danh Sach Lop',
  );

  List<DetailAttendance> detailAttendances = [
    DetailAttendance(
      studentId: 'Student001',
      courseId : 'S1',
      isPresent: false,
      updateTime: DateTime.now(),
      checkInTime: DateTime.now(),
      checkOutTime: DateTime.now(),
      studentName: 'Thanh Binh',
    ),
    // Add more DetailAttendance objects as needed
  ];

  runApp(MyApp(
    attendanceSheet: attendanceSheet,
    detailAttendances: detailAttendances,
  ));
}

class MyApp extends StatelessWidget {
  final AttendanceSheet attendanceSheet;
  final List<DetailAttendance> detailAttendances;

  const MyApp({
    required this.attendanceSheet,
    required this.detailAttendances,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AuthenticationWrapper(
          attendanceSheet: attendanceSheet,
          detailAttendances: detailAttendances,
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  final AttendanceSheet attendanceSheet;
  final List<DetailAttendance> detailAttendances;

  const AuthenticationWrapper({
    required this.attendanceSheet,
    required this.detailAttendances,
  });

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  String? userRole;

  void loginSuccess(String role) {
    if (role != userRole) {
      setState(() {
        userRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userRole == 'professor'
        ? ProfessorScreenPage.ProfessorScreen(
      loggedInProfessorId: 'YourProfessorIDHere', // Thay thế bằng ID của giảng viên đã đăng nhập
      professorCourses: [], // Thay thế bằng danh sách các khóa học của giảng viên
      attendanceSheet: widget.attendanceSheet,
      detailAttendances: widget.detailAttendances,
    )
        : Container();
  }
}
