class Attendance {
  final String studentID;
  final String courseID;
  final DateTime dateTime;

  Attendance({
    required this.studentID,
    required this.courseID,
    required this.dateTime,
  });

  // Hàm để điểm danh, lưu thông tin điểm danh vào cơ sở dữ liệu
  static Future<bool> markAttendance(String studentID, String courseID) async {
    try {
      // Gọi API hoặc xử lý để lưu thông tin điểm danh vào cơ sở dữ liệu
      // Ví dụ:
      // final response = await http.post('URL_MARK_ATTENDANCE', body: {
      //   'studentID': studentID,
      //   'courseID': courseID,
      // });
      // if (response.statusCode == 200) {
      //   return true;
      // }
      // return false;

      // Ví dụ tạm thời:
      return true; // Trả về true tạm thời để làm ví dụ
    } catch (e) {
      return false; // Xử lý lỗi ở đây
    }
  }
}
