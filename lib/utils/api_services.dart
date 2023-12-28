 import 'package:http/http.dart' as http;

class APIServices {
  static Future<bool> loginWithStudentID(String studentID) async {
    const url = 'https://your-api-url/login'; // Thay đổi URL API đăng nhập tại đây
    final response = await http.post(
      Uri.parse(url),
      body: {'userID': studentID}, // Gửi mã sinh viên đến API

    );

    if (response.statusCode == 200) {
      // Đăng nhập thành công, API trả về mã trạng thái 200
      // Xử lý logic sau khi đăng nhập thành công
      return true;
    } else {
      // Xử lý logic khi đăng nhập không thành công
      return false;
    }
  }
}
