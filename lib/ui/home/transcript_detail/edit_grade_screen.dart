import 'package:final_exam/bloc/edit_transcipt_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/transcript/grade_point.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/src/provider.dart';

class EditGradePointScreen extends StatefulWidget {
  final GradePoint? gradePoint;
  final int gradeIndex;
  const EditGradePointScreen(
      {Key? key, required this.gradePoint, required this.gradeIndex})
      : super(key: key);

  @override
  _EditGradePointScreenState createState() => _EditGradePointScreenState();
}

class _EditGradePointScreenState extends State<EditGradePointScreen> {
  TextEditingController _literatureController = TextEditingController();
  TextEditingController _mathController = TextEditingController();
  TextEditingController _englishController = TextEditingController();
  TextEditingController _geographyController = TextEditingController();
  TextEditingController _physicsController = TextEditingController();
  FocusNode _mathNode = FocusNode();
  FocusNode _englishNode = FocusNode();
  FocusNode _geographyNode = FocusNode();
  FocusNode _physicsNode = FocusNode();
  late EditStudentTranscriptBloC _editBloC;

  @override
  void initState() {
    _editBloC = context.read<EditStudentTranscriptBloC>();
    _editBloC.studentGradePoint = widget.gradePoint;
    _literatureController.text =
        widget.gradePoint?.getMarks('Ngữ văn').toString() ?? '0.0';
    _mathController.text =
        widget.gradePoint?.getMarks('Toán').toString() ?? '0.0';
    _englishController.text =
        widget.gradePoint?.getMarks('Anh văn').toString() ?? '0.0';
    _geographyController.text =
        widget.gradePoint?.getMarks('Địa lý').toString() ?? '0.0';
    _physicsController.text =
        widget.gradePoint?.getMarks('Vật lý').toString() ?? '0.0';
    super.initState();
  }

  @override
  void dispose() {
    _literatureController.dispose();
    _mathController.dispose();
    _englishController.dispose();
    _geographyController.dispose();
    _physicsController.dispose();
    _mathNode.dispose();
    _englishNode.dispose();
    _geographyNode.dispose();
    _physicsNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  textField(
                    context,
                    labelText: 'Ngữ văn',
                    controller: _literatureController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (value) => _editBloC.subjectMarks(
                        'Ngữ văn', StringUtil.doubleFromString(value)),
                    onSubmitted: (value) {
                      _mathNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.0),
                  textField(
                    context,
                    labelText: 'Toán',
                    controller: _mathController,
                    focusNode: _mathNode,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (value) => _editBloC.subjectMarks(
                        'Toán', StringUtil.doubleFromString(value)),
                    onSubmitted: (value) {
                      _englishNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.0),
                  textField(
                    context,
                    labelText: 'Anh văn',
                    controller: _englishController,
                    focusNode: _englishNode,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (value) => _editBloC.subjectMarks(
                        'Anh văn', StringUtil.doubleFromString(value)),
                    onSubmitted: (value) {
                      _geographyNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.0),
                  textField(
                    context,
                    labelText: 'Địa lý',
                    controller: _geographyController,
                    focusNode: _geographyNode,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (value) => _editBloC.subjectMarks(
                        'Địa lý', StringUtil.doubleFromString(value)),
                    onSubmitted: (value) {
                      _physicsNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.0),
                  textField(
                    context,
                    labelText: 'Vật lý',
                    controller: _physicsController,
                    focusNode: _physicsNode,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (value) => _editBloC.subjectMarks(
                        'Vật lý', StringUtil.doubleFromString(value)),
                    onSubmitted: (value) {},
                  ),
                  SizedBox(height: 18.0),
                  _buildConductOptions(context),
                ],
              ),
            ),
          ),
          _saveButton(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: BackButton(),
      title: Text(
        widget.gradeIndex == 0
            ? 'Lớp 10'
            : widget.gradeIndex == 1
                ? 'Lớp 11'
                : 'Lớp 12',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _buildConductOptions(BuildContext context) {
    return RadioGroup<String>.builder(
      direction: Axis.horizontal,
      activeColor: AppColor.colorDarkBlue,
      horizontalAlignment: MainAxisAlignment.start,
      groupValue: _editBloC.studentConduct,
      spacebetween: 200,
      onChanged: (value) {
        _editBloC.conduct = value!;
        setState(() {});
      },
      items: ["Tốt", "Khá", "Trung bình"],
      itemBuilder: (item) => RadioButtonBuilder(
        item,
        textPosition: RadioButtonTextPosition.right,
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledColor: AppColor.colorGrey97,
        minWidth: double.infinity,
        height: 54,
        color: AppColor.colorDarkBlue,
        onPressed: updateStudent,
        child: Text(
          'Cập nhật',
          style: TextStyle(
            color: AppColor.colorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  void updateStudent() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _editBloC.editStudentTranscript(widget.gradeIndex).then((newTranscript) {
      _editBloC.transcript = newTranscript;
      context.read<HomeBloC>().updateStudentTranscript(newTranscript);
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Cập nhật');
        },
      ).then((value) => Navigator.pop(context));
    }).catchError((error) {
      _editBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
