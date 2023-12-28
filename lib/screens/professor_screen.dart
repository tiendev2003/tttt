import 'dart:convert'; // Add this line at the beginning of your Dart file
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '/models/attendance_sheet.dart';
import '/models/detail_attendance.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;


  class QRScreen extends StatelessWidget {
    final String qrData;

    const QRScreen({Key? key, required this.qrData}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('QR Code')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: qrData,
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text('QR Data: $qrData', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }
  }
  class StudentAttendanceList extends StatefulWidget {
    final List<DetailAttendance> studentAttendances;

    const StudentAttendanceList({Key? key, required this.studentAttendances}) : super(key: key);

    @override
    _StudentAttendanceListState createState() => _StudentAttendanceListState();
  }

  class _StudentAttendanceListState extends State<StudentAttendanceList> {
    @override
    Widget build(BuildContext context) {
      return Expanded(
        child: ListView.builder(
          itemCount: widget.studentAttendances.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Student ID: ${widget.studentAttendances[index].studentId}'),
              trailing: Checkbox(
                value: widget.studentAttendances[index].isPresent,
                onChanged: (value) {
                  setState(() {
                    widget.studentAttendances[index].isPresent = value ?? false;
                  });
                },
              ),
            );
          },
        ),
      );
    }
  }



  class ProfessorScreen extends StatefulWidget {
    final String loggedInProfessorId;
    final List<AttendanceSheet> professorCourses;
    final AttendanceSheet attendanceSheet;
    final List<DetailAttendance> detailAttendances;

    ProfessorScreen({
      required this.loggedInProfessorId,
      required this.professorCourses,
      required this.attendanceSheet,
      required this.detailAttendances,
    });

    @override
    _ProfessorScreenState createState() => _ProfessorScreenState();
  }
  
  class _ProfessorScreenState extends State<ProfessorScreen> {
    late List<AttendanceSheet> selectedCourses;

    String generateUniqueAttendanceId() {
      // Implement your logic to generate a unique attendance ID here
      // You can use a package like `uuid` to generate unique IDs
      // For example:
      String uniqueId = UniqueKey().toString();
      return uniqueId;
    }

    String findAttendanceIdForCourse(String courseId) {
      // Implement logic to find the attendance ID for a particular course
      // This could involve searching through your data structures or database
      // For demonstration, let's assume you have the attendance ID stored somewhere
      // and you can retrieve it based on the courseId
      String attendanceId = ""; // Replace this with your logic to find the ID
      return attendanceId;
    }


    @override
    void initState() {
      super.initState();
      selectedCourses = widget.professorCourses;
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Professor Screen'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.qr_code),
              onPressed: _scanQRCode,
              tooltip: 'Generate QR Code for Attendance',
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(' '),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('QR Scanner'),
                leading: Icon(Icons.qr_code),
                onTap: _scanQRCode,
              ),
              ListTile(
                title: Text('Thông Tin Giảng Viên'),
                leading: Icon(Icons.person),
                onTap: _showProfessorInfo,
              ),
              ListTile(
                title: Text('Quản Lý Học Phần'),
                leading: Icon(Icons.book),
                onTap: () {
                  Navigator.pop(context);
                  _manageCourses();
                },
              ),
              ListTile(
                title: Text('Quản Lý Sinh Viên'),
                leading: Icon(Icons.person),
                onTap: _manageStudents,
              ),
              // Các mục Drawer khác...
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Danh sách các lớp học phần:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: selectedCourses.length,
                separatorBuilder: (context, index) => Divider(height: 0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(selectedCourses[index].courseId),
                        onTap: () {
                          _showCourseOptions(selectedCourses[index]);
                        },
                        trailing: ElevatedButton(
                          onPressed: () {
                            _takeAttendance(selectedCourses[index]);

                          },
                          child: Text('Attendance'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _updateLectureContent();
                },
                tooltip: 'Update Lecture Content',
              ),
              IconButton(
                icon: Icon(Icons.group),
                onPressed: () {
                  _updateAbsentStudentsList();
                },
                tooltip: 'Update Absent Students List',
              ),
              // Other IconButton widgets...
            ],
          ),
        ),
      );
    }

    void _generateAttendanceQR(AttendanceSheet course) async {
      setState(() {
        widget.detailAttendances.forEach((studentAttendance) {
          if (studentAttendance.courseId == course.courseId) {
            studentAttendance.isPresent = false; // Set students to Absent
          }
        });
      });

      String attendanceId = generateUniqueAttendanceId();
      await _saveAttendance(course.courseId, attendanceId);
      String qrData = "Attendance ID: $attendanceId for Course ID: ${course.courseId}";

      // Generate QR code and encode to Base64
      Barcode qrCode = Barcode.qrCode();
      final Widget qrCodeWidget = BarcodeWidget(
        barcode: qrCode,
        data: qrData,
        width: 200,
        height: 200,
      );

      final Uint8List? imageUint8List = await _capturePng(qrCodeWidget);
      final String attendanceQRImageBase64 = base64Encode(imageUint8List!);

      // Use this encoded string as needed, e.g., storing in the database or sending via API
      print("Attendance QR Image Base64: $attendanceQRImageBase64");
    }

    Future<Uint8List?> _capturePng(Widget widget) async {
      try {
        RenderRepaintBoundary boundary = RenderRepaintBoundary();
        RenderObject? renderObject = boundary;
        if (renderObject != null) {
          Size logicalSize = renderObject.paintBounds.size;
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          return byteData?.buffer.asUint8List();
        } else {
          throw Exception('RenderObject was null');
        }
      } catch (e) {
        print("Error capturing image: $e");
        return null;
      }
    }
    Future<ui.Image> _widgetToImage(Widget widget) async {
      // This function converts a widget into a ui.Image
      RenderRepaintBoundary boundary = RenderRepaintBoundary();
      RenderObject? renderObject = boundary;
      if (renderObject != null) {
        Size logicalSize = renderObject.paintBounds.size;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        return image;
      }
      throw Exception('RenderObject was null');
    }


    // API call to save attendance data
    Future<void> _saveAttendance(String courseId, String attendanceId) async {
      String apiUrl = 'http://188.166.254.1:8080/api/officer/saveAttendance';
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: jsonEncode({'courseId': courseId, 'attendanceId': attendanceId}),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          // Handle successful response if needed
        } else {
          // Handle error for unsuccessful response
          _showErrorDialog('Failed to save attendance data.');
        }
      } catch (e) {
        // Handle network error when making the request
        _showErrorDialog('Network error occurred while saving attendance.');
      }
    }


    // API call to update attendance data
    Future<void> _updateAttendance(String attendanceId, List<DetailAttendance> studentAttendances) async {
      String apiUrl = 'http://188.166.254.1:8080/api/officer/updateAttendance';
      // Prepare the list of absent student IDs
      List<String> absentStudentIds = studentAttendances
          .where((student) => !student.isPresent)
          .map((student) => student.studentId)
          .toList();

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: jsonEncode({
            'attendanceId': attendanceId,
            'absentStudentIds': absentStudentIds
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          // Handle successful response
          print('Attendance updated successfully');
        } else {
          // Handle error
          print('Error updating attendance: ${response.statusCode}');
          print('Response body: ${response.body}');
          _showErrorDialog('Failed to update attendance data: ${response.statusCode}');
        }
      } on SocketException catch (e) {
        print('SocketException: $e');
        _showErrorDialog('Network error: SocketException occurred while updating attendance');
      } on HttpException catch (e) {
        print('HttpException: $e');
        _showErrorDialog('HTTP error: HttpException occurred while updating attendance');
      } catch (e) {
        print('General error: $e');
        _showErrorDialog('An error occurred while updating attendance: $e');
      }
    }
    void _takeAttendance(AttendanceSheet course) {
      TextEditingController contentController = TextEditingController();
      String courseId = course.courseId; // Assuming courseId is accessible in AttendanceSheet

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tạo nội dung buổi học'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: contentController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Nhập nội dung buổi học',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Tạo QR điểm danh'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _generateAttendanceQR(course); // Pass course to generate QR
                },
              ),
              TextButton(
                child: Text('Điểm danh'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _recordAttendance(courseId, contentController.text);

                  // Get absent students for the current course
                  List<DetailAttendance> absentStudents = widget.detailAttendances
                      .where((studentAttendance) =>
                  studentAttendance.courseId == courseId && !studentAttendance.isPresent)
                      .toList();

                  // Show absent students in a dialog
                  _showAbsentStudentsDialog(absentStudents);
                },
              ),
            ],
          );
        },
      );
    }


    void _recordAttendance(String courseId, String content) {
      // Set Status (isPresent) to true for students in widget.detailAttendances
      widget.detailAttendances.forEach((studentAttendance) {
        if (studentAttendance.courseId == courseId) {
          studentAttendance.isPresent = true; // Set students to Present
        }
      });

      // Identify the attendanceId for this session (previously generated)
      String attendanceId = findAttendanceIdForCourse(courseId);

      // Call a function to save/update attendance with attendanceId and details
      _updateAttendance(attendanceId, widget.detailAttendances);
    }


    void _generateQRCode(AttendanceSheet course, int session) {
      String qrData = "Attendance for Session $session of ${course.courseId}";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScreen(qrData: qrData),
        ),
      );
    }
    void _showAbsentStudentsDialog(List<DetailAttendance> absentStudents) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Danh sách học sinh vắng buổi học'),
            content: SingleChildScrollView(
              child: ListBody(
                children: absentStudents.map((student) {
                  return ListTile(
                    title: Text('Student ID: ${student.studentId}'),
                    // You can display other student information here if needed
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    }


    void _showQRScreen(String studentId) {
      String qrData = "Student ID: $studentId";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScreen(qrData: qrData),
        ),
      );
    }

// Function to display error dialog
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }


    void _showCourseOptions(AttendanceSheet course) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Course Options'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    title: Text('Selected Course: ${course.courseId}'),
                  ),
                  // Add other options related to the selected course here
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _showProfessorInfo() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông Tin Giảng Viên'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Professor ID: ${widget.loggedInProfessorId}'),
                  // Display other professor information here
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _manageCourses() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quản Lý Học Phần Đã Chọn'),
            content: SingleChildScrollView(
              child: ListBody(
                children: selectedCourses.map((course) {
                  return ListTile(
                    title: Text(course.courseId),
                    onTap: () {
                      _handleCourseManagement(course);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    }

    void _handleCourseManagement(AttendanceSheet selectedCourse) {
      print('Giảng viên quản lý lớp học phần: ${selectedCourse.courseId}');
      // Perform actions related to course management here
    }

    void _manageStudents() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông Tin Sinh Viên'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Selected Course: ${widget.attendanceSheet.courseId}'),
                  // Display student information or management options here
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _updateLectureContent() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Lecture Content'),
            content: Text('You can update the content of the lecture here.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Perform update lecture content action here
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    void _updateAbsentStudentsList() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Absent Students List'),
            content: Text('You can update the list of absent students here.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Perform update absent students list action here
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    void _scanQRCode() async {
      // Assume we get the course ID and other necessary data from the current state
      String courseId = "some_course_id";
      // Generate the attendance ID and QR code data here
      String attendanceId = "some_attendance_id"; // This should be generated uniquely
      String qrData = "Attendance ID: $attendanceId for Course ID: $courseId";

      try {
        // Display the QR code
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScreen(qrData: qrData),
          ),
        );
      } catch (e) {
        _showErrorDialog('Error generating QR code: $e');
      }
    }
  }



  
