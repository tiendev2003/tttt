import 'package:flutter/material.dart';
import '/models/detail_attendance.dart';
 
class AttendanceListItem extends StatelessWidget {
  final DetailAttendance attendance;
  final VoidCallback onTap;

  const AttendanceListItem({
    required this.attendance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Student ID: ${attendance.studentId}'),
      subtitle: Text('Is Present: ${attendance.isPresent}'),
      trailing: IconButton(
        icon: Icon(attendance.isPresent ? Icons.check : Icons.close),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }
}
