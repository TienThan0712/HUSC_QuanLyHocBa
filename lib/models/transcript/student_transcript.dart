import 'package:final_exam/models/transcript/grade_point.dart';
import 'package:final_exam/models/transcript/student.dart';

class StudentTranscipt {
  Student? student;
  GradePoint? studentGrade10Point;
  GradePoint? studentGrade11Point;
  GradePoint? studentGrade12Point;

  StudentTranscipt(
      {this.student,
      this.studentGrade10Point,
      this.studentGrade11Point,
      this.studentGrade12Point});

  StudentTranscipt.fromJson(Map<String, dynamic> json) {
    if (json['student'] != null) {
      student = Student.fromJson(json['student']);
    }
    if (json['studentGrade10Point'] != null) {
      studentGrade10Point = GradePoint.fromJson(json['studentGrade10Point']);
    }
    if (json['studentGrade11Point'] != null) {
      studentGrade11Point = GradePoint.fromJson(json['studentGrade11Point']);
    }
    if (json['studentGrade12Point'] != null) {
      studentGrade12Point = GradePoint.fromJson(json['studentGrade12Point']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (student != null) {
      data['student'] = this.student!.toJson();
    }
    if (studentGrade10Point != null) {
      data['studentGrade10Point'] = this.studentGrade10Point!.toJson();
    }
    if (studentGrade11Point != null) {
      data['studentGrade11Point'] = this.studentGrade11Point!.toJson();
    }
    if (studentGrade12Point != null) {
      data['studentGrade12Point'] = this.studentGrade12Point!.toJson();
    }
    return data;
  }
}
