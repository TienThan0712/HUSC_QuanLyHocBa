class SubjectMarks {
  String? subjectName;
  bool? isMainSubject;
  double? GPA;

  SubjectMarks({this.subjectName, this.GPA, this.isMainSubject = false});

  SubjectMarks.fromJson(Map<String, dynamic> json) {
    subjectName = json['subjectName'];
    GPA = json['GPA'];
    isMainSubject = json['isMainSubject'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectName'] = this.subjectName;
    data['GPA'] = this.GPA;
    data['isMainSubject'] = this.isMainSubject;
    return data;
  }
}
