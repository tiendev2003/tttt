import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '/models/attendance_sheet.dart';
import '/models/detail_attendance.dart';

class AttendanceSheetScreen extends StatefulWidget {
  final AttendanceSheet attendanceSheet;
  final List<DetailAttendance> detailAttendances;

  AttendanceSheetScreen({
    required this.attendanceSheet,
    required this.detailAttendances,
  });

  @override
  _AttendanceSheetScreenState createState() => _AttendanceSheetScreenState();
}

class _AttendanceSheetScreenState extends State<AttendanceSheetScreen> {
  int selectedSession = 1;
  int numberOfSessions = 15;
  late TextEditingController sessionController;
  List<bool> isStudentAbsent = [];

  @override
  void initState() {
    super.initState();
    sessionController = TextEditingController(text: selectedSession.toString());
    isStudentAbsent = List.generate(widget.detailAttendances.length, (index) => false);
  }

  void _updateSession(String value) {
    setState(() {
      selectedSession = int.parse(value);
    });
  }

  void _updateNumberOfSessions(String value) {
    setState(() {
      numberOfSessions = int.parse(value);
    });
  }

  void _markAttendance() {
    // TODO: Add logic to mark attendance based on selectedSession and isStudentAbsent
    // ...
    // After marking attendance, show QR code or perform any other action
    _showQRScreen();
  }

  void _showQRScreen() {
    String qrData = "Attendance for Session $selectedSession"; // Customize QR data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScreen(qrData: qrData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Sheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${widget.attendanceSheet.course}'), // Assuming course is a property of AttendanceSheet
            Text('Date: ${widget.attendanceSheet.date.toString()}'), // Assuming date is a property of AttendanceSheet
            SizedBox(height: 16.0),
            Text('Session'),
            TextField(
              controller: sessionController,
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateSession(value),
            ),
            SizedBox(height: 16.0),
            Text('Number of Sessions'),
            DropdownButton<String>(
              value: numberOfSessions.toString(),
              items: List.generate(30, (index) => (index + 1).toString())
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  _updateNumberOfSessions(value);
                }
              },
            ),
            SizedBox(height: 16.0),
            Text('Absent Students:'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.detailAttendances.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text('Student ID: ${widget.detailAttendances[index].studentId}'),
                    value: isStudentAbsent[index],
                    onChanged: (value) {
                      setState(() {
                        isStudentAbsent[index] = value!;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _markAttendance,
              child: Text('Mark Attendance and Generate QR'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScreen extends StatelessWidget {
  final String qrData;

  const QRScreen({Key? key, required this.qrData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Attendance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: qrData,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20.0),
            Text(
              'Scan QR code for attendance',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
