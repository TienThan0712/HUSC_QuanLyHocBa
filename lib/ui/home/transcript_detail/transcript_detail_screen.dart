import 'package:final_exam/bloc/edit_transcipt_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/transcript/grade_point.dart';
import 'package:final_exam/models/transcript/student_transcript.dart';
import 'package:final_exam/ui/home/transcript_detail/edit_grade_screen.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class TranscriptDetailScreen extends StatelessWidget {
  final StudentTranscipt transcript;
  const TranscriptDetailScreen({Key? key, required this.transcript})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditStudentTranscriptBloC _editBloC =
        context.read<EditStudentTranscriptBloC>();
    _editBloC.transcript = transcript;
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<StudentTranscipt>(
          stream: _editBloC.transcriptStream,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            StudentTranscipt data = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(24.0),
              children: [
                Text(
                  '''${data.student!.fullName}''',
                  style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5.0),
                buildRichText(context,
                    text: "Mã học sinh: ",
                    highlightText: ' ${data.student!.studentCode}'),
                SizedBox(height: 5.0),
                buildRichText(context,
                    text: "Giới tính: ",
                    highlightText: data.student!.gender! ? "Nam" : "Nữ"),
                SizedBox(height: 5.0),
                buildRichText(context,
                    text: "Ngày sinh: ",
                    highlightText: ' ${data.student!.dateOfBirth}'),
                SizedBox(height: 12.0),
                _buildGradePoint(context, data.studentGrade10Point, 0),
                _buildGradePoint(context, data.studentGrade11Point, 1),
                _buildGradePoint(context, data.studentGrade12Point, 2),
              ],
            );
          }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: BackButton(),
      title: Text(
        'Học bạ',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
      actions: [
        _buildDeteleButton(context),
      ],
    );
  }

  Widget _buildGradePoint(
      BuildContext context, GradePoint? gradePoint, int gradeIndex) {
    String title = gradeIndex == 0
        ? 'Lớp 10'
        : gradeIndex == 1
            ? 'Lớp 11'
            : 'Lớp 12';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditGradePointScreen(
                gradePoint: gradePoint, gradeIndex: gradeIndex),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xff141A1A1A),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title: ',
              style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.0),
            if (gradePoint?.subjectMarks != null)
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: 10.0,
                runSpacing: 10.0,
                children: gradePoint!.subjectMarks!
                    .map<Widget>((e) => Text(
                          '${e.subjectName!}: ${e.GPA!.toStringAsFixed(2)}',
                          style: e.isMainSubject ?? false
                              ? AppTextStyle.mediumBlack1A
                              : AppTextStyle.regularBlack1A,
                        ))
                    .toList(),
              ),
            SizedBox(height: 5.0),
            Text(
              'Điểm trung bình: ${gradePoint?.GPA != null ? gradePoint!.GPA!.toStringAsFixed(2) : ''}',
              style: AppTextStyle.mediumBlack1A,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5.0),
            Text(
              'Hạnh kiểm: ${gradePoint?.conduct ?? ''}',
              style: AppTextStyle.mediumBlack1A,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5.0),
            Text(
              'Học lực: ${gradePoint?.getAcademicPerformance ?? ''}',
              style: AppTextStyle.mediumBlack1A,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeteleButton(BuildContext context) {
    return IconButton(
      onPressed: () => deleteTranscript(context),
      tooltip: 'Xoá học bạ',
      icon: Icon(
        Icons.delete,
        color: AppColor.colorRed,
      ),
    );
  }

  void deleteTranscript(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialog(
            context, 'Xoá', 'Bạn chắc chắn muốn xoá học bạ này?');
      },
    ).then((acceptDelete) {
      if (acceptDelete ?? false) {
        context
            .read<HomeBloC>()
            .deleteStudentTranscript(transcript)
            .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(StringUtil.stringFromException(error))));
        });
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });
  }
}
