import 'dart:convert';
import 'package:final_exam/models/transcript/student_transcript.dart';
import 'package:final_exam/services/file_services.dart';
import 'package:flutter/services.dart';

//ghi các thông tin của student trong file students.json
class StudentTranscriptServices extends FileServices {
  final String fileName = 'transcript.json';

  ///lấy data học bạ từ file [transcript.json]
  ///trả về default data từ assets nếu không có dữ liệu từ file
  Future<List<StudentTranscipt>> getListStudentTranscript() async {
    try {
      String data = await readData(fileName);
      List jsonData = jsonDecode(data);
      print('jsonData: ${jsonData.toList()}');
      return jsonData
          .map<StudentTranscipt>((e) => StudentTranscipt.fromJson(e))
          .toList();
    } catch (error) {
      print('error: ${error.toString()}');
      String transcriptData =
          await rootBundle.loadString('assets/json/student_transcript.json');
      await writeData(fileName, transcriptData);
      List jsonData = json.decode(transcriptData);
      return jsonData
          .map<StudentTranscipt>((e) => StudentTranscipt.fromJson(e))
          .toList();
    }
  }

  Future<bool> addStudentStranscript(StudentTranscipt transcript) async {
    List<StudentTranscipt> listTranscript = await getListStudentTranscript();
    int index = listTranscript.indexWhere((element) =>
        element.student?.studentCode == transcript.student?.studentCode);
    if (index != -1) {
      throw Exception('Sinh viên đã tồn tại');
    }
    print('transcript: ${transcript.toJson()}');
    listTranscript.insert(0, transcript);
    List<Map<String, dynamic>> list = [];
    listTranscript.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> deleteStudentTranscript(StudentTranscipt transcript) async {
    List<StudentTranscipt> listTranscript = await getListStudentTranscript();
    listTranscript.removeWhere((element) =>
        element.student!.studentCode! == transcript.student!.studentCode!);
    List<Map<String, dynamic>> list = [];
    listTranscript.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<StudentTranscipt> editStudentTranscript(
      StudentTranscipt transcript) async {
    List<StudentTranscipt> listTranscript = await getListStudentTranscript();
    int index = listTranscript.indexWhere((element) =>
        element.student!.studentCode == transcript.student!.studentCode);
    if (index < 0) {
      throw Exception('Học bạ không tồn tại');
    }
    listTranscript[index] = transcript;
    List<Map<String, dynamic>> list = [];
    listTranscript.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return transcript;
  }
}
