import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/screens/student_screen.dart';

final headers = {
  'Content-Type': 'application/json',
  // 'Access-Control-Allow-Origin': '*', // Cho phép truy cập từ mọi nguồn
  // 'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS', // Cho phép các phương thức
  // 'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization', // Cho phép các header
};

// Tạo class để gửi yêu cầu đăng nhập
class LoginRequest {
  String userID;
  String password;

  LoginRequest({
    required this.userID,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'password': password,
    };
  }
}

// Enum để xác định vai trò người dùng
enum UserRole { student, professor, undefined }

class LoginScreen extends StatefulWidget {
  final Function loginSuccessCallback;

  const LoginScreen(this.loginSuccessCallback, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserRole? selectedRole;
  bool isLoading = false;

  Future<void> _login() async {
    if (selectedRole == null) {
      // Hiển thị thông báo nếu người dùng không chọn role
      _handleRoleUndefined();
      return;
    }

    setState(() {
      isLoading = true;
    });

    String userID = _userIDController.text;
    String password = _passwordController.text;

    String apiUrl = selectedRole == UserRole.student
        ? 'http://188.166.254.1:8080/api/students/login'
        : selectedRole == UserRole.professor
            ? 'http://188.166.254.1:8080/api/officers/login'
            : '';

    if (apiUrl.isEmpty) {
      // Hiện thị sẽ báo nếu người dùng không chọn role

      // Hiển thị thông báo nếu role không được xác định
      _handleRoleUndefined();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({
          'username': userID,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // Đăng nhập thành công, chuyển hướng đến màn hình tương ứng
        if (selectedRole == UserRole.student) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StudentScreen(/* pass necessary arguments */),
            ),
          );
        } else if (selectedRole == UserRole.professor) {
          Navigator.pushReplacementNamed(context, '/professor');
        }
      } else {
        // Đăng nhập thất bại, hiển thị thông báo lỗi
        _showLoginFailedDialog();
      }
    } catch (e) {
      // Xử lý exception và hiển thị thông báo lỗi
      _showLoginFailedDialog();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showLoginFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Invalid User ID or Password. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleRoleUndefined() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Role Undefined'),
        content: const Text('The role for this user is undefined.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField<UserRole>(
                      value: selectedRole,
                      onChanged: (UserRole? value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                      items: UserRole.values.map((UserRole role) {
                        return DropdownMenuItem<UserRole>(
                          value: role,
                          child: Text(role.toString().split('.').last),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Select Role',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _userIDController,
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
