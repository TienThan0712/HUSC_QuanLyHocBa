import 'package:final_exam/bloc/add_transcript_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/src/provider.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController _studentCodeController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  FocusNode _studentCodeNode = FocusNode();
  FocusNode _addressNode = FocusNode();
  late AddTranscriptBloC _addTranscriptBloC;

  @override
  void initState() {
    _addTranscriptBloC = context.read<AddTranscriptBloC>();
    _addTranscriptBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _studentCodeController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _studentCodeNode.dispose();
    _addressNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context),
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textField(
                          context,
                          controller: _fullNameController,
                          labelText: 'Họ và tên',
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          onChanged: (value) =>
                              _addTranscriptBloC.fullName = value,
                          onSubmitted: (value) {
                            _studentCodeNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _studentCodeController,
                          focusNode: _studentCodeNode,
                          labelText: 'Mã học sinh',
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 15,
                          onChanged: (value) =>
                              _addTranscriptBloC.studentCode = value,
                          onSubmitted: (value) {
                            _addressNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          labelText: 'Địa chỉ',
                          focusNode: _addressNode,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 200,
                          onChanged: (value) =>
                              _addTranscriptBloC.address = value,
                          onSubmitted: (value) {},
                        ),
                        SizedBox(height: 18.0),
                        _birthdayField(context),
                        SizedBox(height: 18.0),
                        _buildGenderOptions(context),
                      ],
                    ),
                  ),
                ),
                _saveButton(context),
              ],
            ),
          ),
          _loadingState(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: BackButton(),
      title: Text(
        'Thêm học sinh',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _birthdayField(BuildContext context) {
    return TextField(
      controller: _dobController,
      cursorColor: AppColor.colorDarkBlue,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Ngày sinh',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        filled: true,
        fillColor: AppColor.colorGreyEE,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            width: 0.8,
            color: AppColor.colorDarkBlue,
          ),
        ),
        suffixIcon: Icon(
          Icons.calendar_today_rounded,
          size: 23,
        ),
        isDense: true,
      ),
      onTap: pickDOB,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: StreamBuilder<bool>(
          stream: _addTranscriptBloC.saveButtonState,
          builder: (_, snapshot) {
            bool isEnable = snapshot.data ?? false;
            return MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledColor: AppColor.colorGrey97,
              minWidth: double.infinity,
              height: 54,
              color: AppColor.colorDarkBlue,
              onPressed: isEnable ? addStudent : null,
              child: Text(
                'Thêm',
                style: TextStyle(
                  color: AppColor.colorWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              padding: EdgeInsets.all(0),
            );
          }),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _addTranscriptBloC.loadingState,
        builder: (_, snapshot) {
          bool isLoading = snapshot.data ?? false;
          if (isLoading) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColor.colorGrey97.withOpacity(0.5),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox.shrink();
        });
  }

  Widget _buildGenderOptions(BuildContext context) {
    return RadioGroup<bool>.builder(
      direction: Axis.horizontal,
      activeColor: AppColor.colorDarkBlue,
      horizontalAlignment: MainAxisAlignment.start,
      groupValue: _addTranscriptBloC.studentGender,
      spacebetween: 300,
      onChanged: (value) {
        _addTranscriptBloC.gender = value!;
        setState(() {});
      },
      items: [true, false],
      itemBuilder: (item) => RadioButtonBuilder(
        item ? "Nam" : "Nữ",
        textPosition: RadioButtonTextPosition.right,
      ),
    );
  }

  void pickDOB() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      currentTime: _dobController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_dobController.text)
          : DateTime.now(),
      locale: LocaleType.vi,
      onConfirm: (time) {
        _dobController.text = DateFormat('dd/MM/yyyy').format(time);
        _addTranscriptBloC.dob = _dobController.text;
      },
    );
  }

  void addStudent() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _addTranscriptBloC.addStudentTranscript().then((sucess) {
      context.read<HomeBloC>().getListStudentTranscript();
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Thêm học sinh');
        },
      ).then((_) {
        Navigator.pop(context, true);
      });
    }).catchError((error) {
      _addTranscriptBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
