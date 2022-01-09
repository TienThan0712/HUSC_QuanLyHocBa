class Student {
  String? studentCode;
  String? fullName;
  String? dateOfBirth;
  bool? gender; // true: male, false: female
  String? address;

  Student(
      {this.studentCode,
      this.fullName,
      this.dateOfBirth,
      this.gender,
      this.address});

  Student.fromJson(Map<String, dynamic> json) {
    studentCode = json['studentCode'];
    fullName = json['fullName'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentCode'] = this.studentCode;
    data['fullName'] = this.fullName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['address'] = this.address;
    return data;
  }

  bool isFullInformation() {
    if (studentCode == null ||
        fullName == null ||
        dateOfBirth == null ||
        gender == null ||
        address == null) {
      return false;
    }
    return studentCode!.isNotEmpty &&
        fullName!.isNotEmpty &&
        dateOfBirth!.isNotEmpty &&
        address!.isNotEmpty;
  }
}
