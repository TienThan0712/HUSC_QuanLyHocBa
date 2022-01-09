import 'dart:async';

import 'package:rxdart/subjects.dart';

abstract class BaseBloC {
  var _loadingObject = BehaviorSubject<bool>();
  Stream<bool> get loadingState => _loadingObject.stream;

  void showLoading() {
    _loadingObject.add(true);
  }

  void hideLoading() {
    _loadingObject.add(false);
  }

  void clearData();

  void dispose() {
    _loadingObject.close();
  }
}
