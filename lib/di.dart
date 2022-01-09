import 'package:final_exam/bloc/add_transcript_bloc.dart';
import 'package:final_exam/bloc/edit_transcipt_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/bloc/login_bloc.dart';
import 'package:final_exam/bloc/register_bloc.dart';
import 'package:final_exam/services/login_services.dart';
import 'package:final_exam/services/register_services.dart';
import 'package:final_exam/services/student_services.dart';
import 'package:final_exam/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildStatelessWidget> getProvider() {
  List<SingleChildStatelessWidget> independentServices = [
    Provider<LoginServices>(
      create: (BuildContext context) => LoginServices(),
    ),
    Provider<UserServices>(
      create: (BuildContext context) => UserServices(),
    ),
    Provider<RegisterServices>(
      create: (BuildContext context) => RegisterServices(),
    ),
    Provider<StudentTranscriptServices>(
      create: (BuildContext context) => StudentTranscriptServices(),
    ),
  ];

  List<SingleChildStatelessWidget> dependentServices = [
    ProxyProvider<LoginServices, LoginBloC>(
      update: (_, loginServices, previous) =>
          (previous ?? LoginBloC(loginServices)),
      dispose: (_, bloc) => bloc.dispose(),
    ),
    ProxyProvider<RegisterServices, RegisterBloC>(
      update: (_, registerServices, previous) =>
          (previous ?? RegisterBloC(registerServices)),
      dispose: (_, bloc) => bloc.dispose(),
    ),
    ProxyProvider<StudentTranscriptServices, HomeBloC>(
      update: (_, studentServices, previous) =>
          (previous ?? HomeBloC(studentServices)),
      dispose: (_, bloc) => bloc.dispose(),
    ),
    ProxyProvider<StudentTranscriptServices, EditStudentTranscriptBloC>(
      update: (_, studentServices, previous) =>
          (previous ?? EditStudentTranscriptBloC(studentServices)),
      dispose: (_, bloc) => bloc.dispose(),
    ),
    ProxyProvider<StudentTranscriptServices, AddTranscriptBloC>(
      update: (_, studentServices, previous) =>
          (previous ?? AddTranscriptBloC(studentServices)),
      dispose: (_, bloc) => bloc.dispose(),
    ),
  ];

  List<SingleChildStatelessWidget> uiConsumableProviders = [];

  List<SingleChildStatelessWidget> providers = [
    ...independentServices,
    ...dependentServices,
    ...uiConsumableProviders,
  ];
  return providers;
}
