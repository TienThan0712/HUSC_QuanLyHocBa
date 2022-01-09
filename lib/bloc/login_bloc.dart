import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/user.dart';
import 'package:final_exam/services/login_services.dart';
import 'package:rxdart/subjects.dart';

class LoginBloC extends BaseBloC {
  final LoginServices loginServices;
  LoginBloC(this.loginServices);

  String? _userName;
  String? _password;
  var _loginButtonObject = BehaviorSubject<bool>();
  var _hidePasswordObject = BehaviorSubject<bool>();

  Stream<bool> get hidePasswordState => _hidePasswordObject.stream;
  Stream<bool> get loginButtonState => _loginButtonObject.stream;

  set hidePassword(bool value) => _hidePasswordObject.add(value);

  set userName(String value) {
    _userName = value.trim();
    _loginButtonObject.add(_userName!.length > 0 && _password!.length > 0);
  }

  set password(String value) {
    _password = value.trim();
    _loginButtonObject.add(_userName!.length > 0 && _password!.length > 0);
  }

  Future<User> login() async {
    showLoading();
    User user = await loginServices.login(_userName!, _password!);
    hideLoading();
    return user;
  }

  @override
  void dispose() {
    _hidePasswordObject.close();
    _loginButtonObject.close();
    super.dispose();
  }

  @override
  void clearData() {
    _userName = '';
    _password = '';
    _hidePasswordObject.add(true);
    _loginButtonObject.add(false);
  }
}
