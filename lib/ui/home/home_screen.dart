import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/transcript/student_transcript.dart';
import 'package:final_exam/models/user.dart';
import 'package:final_exam/ui/auth/login_screen.dart';
import 'package:final_exam/ui/home/add_student_screen.dart';
import 'package:final_exam/ui/home/transcript_item.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  late HomeBloC _homeBloC;

  @override
  void initState() {
    _homeBloC = context.read<HomeBloC>();
    _homeBloC.clearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: AppColor.colorGreyF5F5F7,
        body: FutureBuilder<List<StudentTranscipt>>(
            future: _homeBloC.getListStudentTranscript(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Đã có lỗi xảy ra.'),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      cursorColor: Colors.black,
                      onChanged: (value) => _homeBloC.searchKey = value,
                      style: AppTextStyle.regularBlack1A,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm',
                        hintStyle: AppTextStyle.regularGreyC9,
                        contentPadding:
                            EdgeInsets.only(top: 16, left: 10, right: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1),
                          borderSide: BorderSide(
                            color: AppColor.colorGreyF5,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<StudentTranscipt>>(
                        stream: _homeBloC.listTranscriptStream,
                        initialData: snapshot.data,
                        builder: (__, listSnapshot) {
                          if (listSnapshot.data!.isEmpty) {
                            return Center(
                              child: Text('Danh sách rỗng.'),
                            );
                          }
                          List<StudentTranscipt> _list = listSnapshot.data!;
                          return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 50.0),
                            itemBuilder: (context, index) {
                              return TranscriptItem(
                                key: Key(
                                    'student ${_list[index].student!.studentCode}'),
                                transcript: _list[index],
                              );
                            },
                          );
                        }),
                  ),
                ],
              );
            }),
        floatingActionButton: _addStudentButton(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.colorGreyF5F5F7,
      title: Text(
        'Quản lý học bạ',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () => logout(context),
          child: Text('Đăng xuất'),
        ),
      ],
    );
  }

  Widget _addStudentButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddStudentScreen()))
            .then((addSuccess) {
          if (addSuccess ?? false) {
            _homeBloC.searchKey = '';
            _searchController.clear();
          }
        });
      },
      backgroundColor: AppColor.colorDarkBlue,
      child: Icon(
        Icons.add,
        color: AppColor.colorWhite,
      ),
    );
  }

  void logout(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialog(
            context, 'Đăng xuất', 'Bạn chắc chắn muốn đăng xuất?');
      },
    ).then((acceptLogout) {
      if (acceptLogout ?? false) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      }
    });
  }
}
