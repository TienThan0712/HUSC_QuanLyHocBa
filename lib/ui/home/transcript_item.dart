import 'package:final_exam/models/transcript/student_transcript.dart';
import 'package:final_exam/ui/home/transcript_detail/transcript_detail_screen.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TranscriptItem extends StatefulWidget {
  final StudentTranscipt transcript;
  const TranscriptItem({Key? key, required this.transcript}) : super(key: key);

  @override
  _TranscriptItemState createState() => _TranscriptItemState();
}

class _TranscriptItemState extends State<TranscriptItem> {
  late StudentTranscipt transcript;
  @override
  void initState() {
    transcript = widget.transcript;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: moveToDetail,
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
              '''${transcript.student!.fullName}''',
              style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10.0),
            buildRichText(context,
                text: "Mã học sinh: ",
                highlightText: ' ${transcript.student!.studentCode}'),
            buildRichText(context,
                text: "Giới tính: ",
                highlightText: transcript.student!.gender! ? "Nam" : "Nữ"),
            buildRichText(context,
                text: "Ngày sinh: ",
                highlightText: ' ${transcript.student!.dateOfBirth}'),
            buildRichText(context,
                text: "Địa chỉ: ",
                highlightText: ' ${transcript.student!.address}'),
            SizedBox(height: 10.0),
            Text(
              'Điểm trung bình: ',
              style: AppTextStyle.mediumBlack1A,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRichText(context,
                    text: "Lớp 10: ",
                    highlightText:
                        ' ${transcript.studentGrade10Point?.GPA?.toStringAsFixed(2) ?? ''}'),
                buildRichText(context,
                    text: "Lớp 11: ",
                    highlightText:
                        ' ${transcript.studentGrade11Point?.GPA?.toStringAsFixed(2) ?? ''}'),
                buildRichText(context,
                    text: "Lớp 12: ",
                    highlightText:
                        ' ${transcript.studentGrade12Point?.GPA?.toStringAsFixed(2) ?? ''}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void moveToDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => TranscriptDetailScreen(transcript: transcript)),
    );
  }
}
