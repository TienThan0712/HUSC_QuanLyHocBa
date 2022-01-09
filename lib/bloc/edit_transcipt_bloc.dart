import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/transcript/grade_point.dart';
import 'package:final_exam/models/transcript/student_transcript.dart';
import 'package:final_exam/models/transcript/subject_marks.dart';
import 'package:final_exam/services/student_services.dart';
import 'package:rxdart/subjects.dart';

class EditStudentTranscriptBloC extends BaseBloC {
  final StudentTranscriptServices studentServices;
  EditStudentTranscriptBloC(this.studentServices);

  late GradePoint _studentGradePoint;

  var _transcriptObject = BehaviorSubject<StudentTranscipt>();
  Stream<StudentTranscipt> get transcriptStream => _transcriptObject.stream;

  set transcript(StudentTranscipt value) => _transcriptObject.add(value);

  set studentGradePoint(GradePoint? value) {
    _studentGradePoint = value ?? GradePoint(subjectMarks: []);
  }

  set conduct(String value) {
    _studentGradePoint.conduct = value;
  }

  void subjectMarks(String subjectName, double? marks) {
    int index = _studentGradePoint.subjectMarks!.indexWhere((element) =>
        element.subjectName!.toLowerCase() == subjectName.toLowerCase());
    if (index >= 0) {
      _studentGradePoint.subjectMarks![index] = SubjectMarks(
          subjectName: subjectName,
          GPA: marks,
          isMainSubject: subjectName == 'Ngữ văn' || subjectName == 'Toán');
    } else {
      _studentGradePoint.subjectMarks!.insert(
          0,
          SubjectMarks(
              subjectName: subjectName,
              GPA: marks,
              isMainSubject:
                  subjectName == 'Ngữ văn' || subjectName == 'Toán'));
    }
  }

  String get studentConduct => _studentGradePoint.conduct ?? '';

  /// [gradeIndex]
  /// 0: grade10points
  /// 1: grade11Points
  /// 2: grade12Points
  Future<StudentTranscipt> editStudentTranscript(int gradeIndex) async {
    if (!_studentGradePoint.isValid()) {
      throw Exception('Điểm số sai định dạng.');
    }
    showLoading();
    StudentTranscipt _transcript = _transcriptObject.value;
    switch (gradeIndex) {
      case 0:
        _transcript.studentGrade10Point = _studentGradePoint;
        break;
      case 1:
        _transcript.studentGrade11Point = _studentGradePoint;
        break;
      case 2:
        _transcript.studentGrade12Point = _studentGradePoint;
        break;
      default:
        break;
    }
    StudentTranscipt result =
        await studentServices.editStudentTranscript(_transcript);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
  }

  @override
  void dispose() {
    _transcriptObject.close();
    super.dispose();
  }
}
