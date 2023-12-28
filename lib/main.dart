import 'package:flutter/material.dart';
import '/screens/login_screen.dart';
import '/screens/student_screen.dart';
import '/screens/professor_screen.dart';
import '/models/attendance_sheet.dart';
import '/models/detail_attendance.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  String? role;

  void loginSuccess(String userRole) {
    setState(() {
      role = userRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return LoginScreen(loginSuccess);
    } else if (role == 'Student') {
      return StudentScreen();
    } else if (role == 'Professor') {
      // Create an instance of AttendanceSheet
      AttendanceSheet yourAttendanceSheetObject = AttendanceSheet(
        courseId: 'Math101',
        teachDate: DateTime(2023, 12, 15),
        startTime: DateTime(2023, 12, 15, 9, 0),
        endTime: DateTime(2023, 12, 15, 11, 0),
        lessonContent: 'Introduction to Mathematics',
        date: DateTime.now(),
        topic: 'Your topic here',
        course: 'Danh Sach',
      );

      // Create a list of DetailAttendance objects
      List<DetailAttendance> yourDetailAttendancesList = [
        DetailAttendance(
          studentId: '1',
          courseId: 'S1',
          studentName: 'John Doe',
          isPresent: true,
          updateTime: DateTime.now(),
          checkInTime: DateTime.now(),
          checkOutTime: DateTime.now(),
        ),
        // Add more DetailAttendance objects if needed
      ];

      String loggedInProfessorId =
          'yourProfessorIdHere'; // Replace with the actual professor ID

      // Create a list of AttendanceSheet objects for professor courses
      List<AttendanceSheet> professorCourses = [
        AttendanceSheet(
          courseId: 'Math101',
          teachDate: DateTime(2023, 12, 15),
          startTime: DateTime(2023, 12, 15, 9, 0),
          endTime: DateTime(2023, 12, 15, 11, 0),
          lessonContent: 'Introduction to Mathematics',
          date: DateTime.now(),
          topic: 'Your topic here',
          course: 'Danh Sach',
          // Details of Course 1
          // Ensure each item in the list is an AttendanceSheet object
        ),
        AttendanceSheet(
          courseId: 'Math102',
          teachDate: DateTime(2023, 12, 15),
          startTime: DateTime(2023, 12, 15, 9, 0),
          endTime: DateTime(2023, 12, 15, 11, 0),
          lessonContent: 'Introduction to Mathematics',
          date: DateTime.now(),
          topic: 'Your topic here',
          course: 'Danh Sach',
        ),
        // Add more AttendanceSheet objects if needed for different courses
      ];

      return ProfessorScreen(
        attendanceSheet: yourAttendanceSheetObject,
        detailAttendances: yourDetailAttendancesList,
        loggedInProfessorId: loggedInProfessorId,
        professorCourses: professorCourses,
      );
    } else {
      return LoginScreen(loginSuccess);
    }
  }
}
