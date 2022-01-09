import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/transcript/student_transcript.dart';
import 'package:final_exam/services/student_services.dart';
import 'package:rxdart/subjects.dart';

class HomeBloC extends BaseBloC {
  final StudentTranscriptServices transcriptServices;
  HomeBloC(this.transcriptServices);

  Timer? _debounce;
  late List<StudentTranscipt> _listTranscript;
  late String _searchKey;

  var _listTranscriptsObject = BehaviorSubject<List<StudentTranscipt>>();
  Stream<List<StudentTranscipt>> get listTranscriptStream =>
      _listTranscriptsObject.stream;

  set searchKey(String key) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchKey = key;
      _searchTranscript();
    });
  }

  void _searchTranscript() {
    List<StudentTranscipt> _result = _listTranscript
        .where((element) => element.student!.fullName!
            .toLowerCase()
            .contains(_searchKey.toLowerCase()))
        .toList();
    _listTranscriptsObject.add(_result);
  }

  Future<List<StudentTranscipt>> getListStudentTranscript() async {
    _listTranscript = await transcriptServices.getListStudentTranscript();
    _listTranscriptsObject.add(_listTranscript);
    return _listTranscript;
  }

  void updateStudentTranscript(StudentTranscipt transcript) {
    List<StudentTranscipt> _currentList = _listTranscriptsObject.value;
    int index = _currentList.indexWhere((element) =>
        element.student!.studentCode == transcript.student!.studentCode);
    _currentList[index] = transcript;
    _listTranscript[_listTranscript.indexWhere((element) =>
            element.student!.studentCode == transcript.student!.studentCode)] =
        transcript;
    _listTranscriptsObject.add(_currentList);
  }

  Future<bool> deleteStudentTranscript(StudentTranscipt transcript) async {
    bool deleteSuccess =
        await transcriptServices.deleteStudentTranscript(transcript);
    List<StudentTranscipt> _currentList = _listTranscriptsObject.value;
    _currentList.removeWhere((element) =>
        element.student!.studentCode == transcript.student!.studentCode);
    _listTranscript.removeWhere((element) =>
        element.student!.studentCode == transcript.student!.studentCode);
    _listTranscriptsObject.add(_currentList);
    return deleteSuccess;
  }

  @override
  void clearData() {
    _searchKey = '';
  }

  @override
  void dispose() {
    _listTranscriptsObject.close();
    _debounce?.cancel();
    super.dispose();
  }
}
