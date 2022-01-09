import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/transcript/student.dart';
import 'package:final_exam/models/transcript/student_transcript.dart';
import 'package:final_exam/services/student_services.dart';
import 'package:rxdart/subjects.dart';

class AddTranscriptBloC extends BaseBloC {
  final StudentTranscriptServices studentServices;
  AddTranscriptBloC(this.studentServices);

  late Student _student;

  var _saveButtonObject = BehaviorSubject<bool>();

  Stream<bool> get saveButtonState => _saveButtonObject.stream;

  set studentCode(String value) {
    _student.studentCode = value.trim();
    _saveButtonObject.add(_student.isFullInformation());
  }

  set fullName(String value) {
    _student.fullName = value.trim();
    _saveButtonObject.add(_student.isFullInformation());
  }

  set dob(String value) {
    _student.dateOfBirth = value.trim();
    _saveButtonObject.add(_student.isFullInformation());
  }

  set gender(bool value) {
    _student.gender = value;
    _saveButtonObject.add(_student.isFullInformation());
  }

  set address(String value) {
    _student.address = value.trim();
    _saveButtonObject.add(_student.isFullInformation());
  }

  bool get studentGender => _student.gender ?? true;

  Future<bool> addStudentTranscript() async {
    showLoading();
    bool result = await studentServices.addStudentStranscript(
      StudentTranscipt(
          student: _student,
          studentGrade10Point: null,
          studentGrade11Point: null,
          studentGrade12Point: null),
    );
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
    _saveButtonObject.add(false);
    _student = Student(gender: true);
  }

  @override
  void dispose() {
    _saveButtonObject.close();
    super.dispose();
  }
}
