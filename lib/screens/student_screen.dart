import 'package:flutter/material.dart';
import '/models/student.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: StudentScreen(), // Mở màn hình thông tin sinh viên mặc định
  ));
}

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample student data
    Student loggedInStudent = Student(
      studentCode: 'S12345',
      password: 'password',
      cccd: 'CCCD123',
      name: 'Thanh Binh',
      birthDay: DateTime(21, 08, 2002),
      email: 'nvtbinh.20it4@vku.udn.vn',
      phoneNumber: '123456789',
      familyPhoneNumber: '987654321',
      address: 'Quang Tri',
      gender: 'Male',
      birthPlace: 'Quang Tri',
      className: '20SE4',
      groupCodes: 'Group1',
      qRCodeImage: 'qrcode.jpg',
      status: true,
      createTime: DateTime.now(),
      updateTime: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                    // Đổi 'assets/profile_image.jpg' thành đường dẫn của hình ảnh sinh viên
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Student Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(loggedInStudent.name),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Student Code',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(loggedInStudent.studentCode),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Class Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(loggedInStudent.className),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(loggedInStudent.address),
                ),
                // Add other student information here...
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRScannerScreen(
                  loggedInStudent), // Chuyển đến màn hình quét QR
            ),
          );
        },
        tooltip: 'Scan QR Code',
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  final Student loggedInStudent; // Thêm loggedInStudent ở đây

  QRScannerScreen(this.loggedInStudent, {super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      String studentCode = widget.loggedInStudent.studentCode;
      String qrCodeInfo = scanData.code ?? ''; // Chuyển đổi String? sang String

      String apiUrl = 'http://188.166.254.1:8080/api/officer/updateAttendance';
      Map<String, dynamic> studentData = {
        'studentCode': studentCode,
        'qrCodeInfo': qrCodeInfo,
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: studentData,
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Attendance'),
                content: Text('Attendance recorded for: $qrCodeInfo'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print(
              'Failed to record attendance. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
