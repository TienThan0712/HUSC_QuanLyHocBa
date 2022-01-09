import 'package:final_exam/models/transcript/subject_marks.dart';

class GradePoint {
  String? conduct;
  List<SubjectMarks>? subjectMarks;

  GradePoint({this.conduct, this.subjectMarks});

  GradePoint.fromJson(Map<String, dynamic> json) {
    conduct = json['conduct'];
    if (json['subjectMarks'] != null) {
      subjectMarks = json['subjectMarks']
          .map<SubjectMarks>((e) => SubjectMarks.fromJson(e))
          .toList();
    } else {
      subjectMarks = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conduct'] = this.conduct;
    if (subjectMarks != null) {
      List list = [];
      subjectMarks!.forEach((element) {
        list.add(element.toJson());
      });
      data['subjectMarks'] = list;
    }
    return data;
  }

  double? get GPA {
    if (subjectMarks == null || subjectMarks!.isEmpty) {
      return null;
    }
    double totalMarks = 0.0;
    int count = 0;
    if (subjectMarks!.any((element) => element.GPA == null)) {
      return null;
    }
    subjectMarks!.forEach((element) {
      if (element.isMainSubject ?? false) {
        count += 2;
        totalMarks += 2 * (element.GPA!);
      } else {
        count++;
        totalMarks += element.GPA!;
      }
    });
    return totalMarks / count;
  }

  String get getAcademicPerformance {
    if (GPA == null) {
      return "";
    }
    if (GPA! >= 8.0) {
      return "Giỏi";
    }
    if (GPA! >= 6.5 && GPA! < 8.0) {
      return "Khá";
    }
    return "Trung bình";
  }

  double getMarks(String subjectName) {
    if (subjectMarks == null || subjectMarks!.isEmpty) {
      return 0.0;
    }
    SubjectMarks marks = subjectMarks!.firstWhere((element) =>
        element.subjectName!.toLowerCase().contains(subjectName.toLowerCase()));
    return marks.GPA ?? 0.0;
  }

  bool isValid() {
    bool isInValid =
        subjectMarks?.any((element) => element.GPA! > 10 || element.GPA! < 0) ??
            true;
    return !isInValid;
  }
}
