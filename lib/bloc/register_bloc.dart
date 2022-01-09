import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/user.dart';
import 'package:final_exam/services/register_services.dart';
import 'package:rxdart/subjects.dart';

class RegisterBloC extends BaseBloC {
  final RegisterServices registerServices;
  RegisterBloC(this.registerServices);

  late User _registerUserInformation;
  late String _confirmPassword;
  var _registerButtonObject = BehaviorSubject<bool>();

  Stream<bool> get registerButtonState => _registerButtonObject.stream;

  set userName(String value) {
    _registerUserInformation.userName = value.trim();
    _registerButtonObject.add(_registerUserInformation.isFullInformation() &&
        _confirmPassword.length > 0);
  }

  set password(String value) {
    _registerUserInformation.password = value.trim();
    _registerButtonObject.add(_registerUserInformation.isFullInformation() &&
        _confirmPassword.length > 0);
  }

  set fullName(String value) {
    _registerUserInformation.fullName = value.trim();
    _registerButtonObject.add(_registerUserInformation.isFullInformation() &&
        _confirmPassword.length > 0);
  }

  set address(String value) {
    _registerUserInformation.address = value.trim();
    _registerButtonObject.add(_registerUserInformation.isFullInformation() &&
        _confirmPassword.length > 0);
  }

  set email(String value) {
    _registerUserInformation.email = value.trim();
    _registerButtonObject.add(_registerUserInformation.isFullInformation() &&
        _confirmPassword.length > 0);
  }

  set confirmPassword(String value) {
    _confirmPassword = value.trim();
    _registerButtonObject.add(_registerUserInformation.isFullInformation() &&
        _confirmPassword.length > 0);
  }

  Future<bool> register() async {
    showLoading();
    if (_registerUserInformation.password != _confirmPassword) {
      hideLoading();
      throw Exception('Nhập lại mật khẩu không đúng.');
    }
    bool isSuccess = await registerServices.register(_registerUserInformation);
    hideLoading();
    return isSuccess;
  }

  @override
  void dispose() {
    _registerButtonObject.close();
    super.dispose();
  }

  @override
  void clearData() {
    _registerUserInformation = User();
    _confirmPassword = '';
    _registerButtonObject.add(false);
  }
}
