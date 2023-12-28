  import 'package:intl/intl.dart';

  class Student {
    late String studentCode;
    late String password; // Có thể cần sử dụng các thư viện khác để mã hóa mật khẩu, như bcrypt
    late String cccd;
    late String name;
    late DateTime birthDay; // Có thể sử dụng kiểu DateTime
    late String email;
    late String phoneNumber;
    late String familyPhoneNumber;
    late String address;
    late String gender;
    late String birthPlace;
    late String className;
    late String groupCodes;
    late String qRCodeImage;
    late bool status;
    late DateTime createTime;
    late DateTime updateTime;

    Student({
      required this.studentCode,
      required this.password,
      required this.cccd,
      required this.name,
      required this.birthDay,
      required this.email,
      required this.phoneNumber,
      required this.familyPhoneNumber,
      required this.address,
      required this.gender,
      required this.birthPlace,
      required this.className,
      required this.groupCodes,
      required this.qRCodeImage,
      required this.status,
      required this.createTime,
      required this.updateTime,
    });

    factory Student.fromJson(Map<String, dynamic> json) {
      return Student(
        studentCode: json['studentCode'],
        password: json['password'],
        cccd: json['cccd'],
        name: json['name'],
        birthDay: DateTime.parse(json['birthDay']), // Chuyển đổi chuỗi sang DateTime
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        familyPhoneNumber: json['familyPhoneNumber'],
        address: json['address'],
        gender: json['gender'],
        birthPlace: json['birthPlace'],
        className: json['className'],
        groupCodes: json['groupCodes'],
        qRCodeImage: json['qRCodeImage'],
        status: json['status'],
        createTime: DateTime.parse(json['createTime']),
        updateTime: DateTime.parse(json['updateTime']),
      );
    }

    Map<String, dynamic> toJson() {
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      return {
        'studentCode': studentCode,
        'password': password,
        'cccd': cccd,
        'name': name,
        'birthDay': birthDay,
        'email': email,
        'phoneNumber': phoneNumber,
        'familyPhoneNumber': familyPhoneNumber,
        'address': address,
        'gender': gender,
        'birthPlace': birthPlace,
        'className': className,
        'groupCodes': groupCodes,
        'qRCodeImage': qRCodeImage,
        'status': status,
        'createTime': formatter.format(createTime),
        'updateTime': formatter.format(updateTime),
      };
    }
  }
