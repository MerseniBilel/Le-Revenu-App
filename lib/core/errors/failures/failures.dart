import 'package:flutter/foundation.dart';
import '../../constants/app_const.dart';

abstract class Failure {
  String get message;
}

class ServerFailure extends Failure {
  final String? msg;

  ServerFailure({required this.msg});

  @override
  String get message => msg ?? AppConst.serverFailureMessage;
}

class UnexpectedFailure extends Failure {
  final String msg;

  UnexpectedFailure({required this.msg});

  @override
  String get message => kDebugMode || kProfileMode
      ? 'UnexpectedFailure => $msg'
      : AppConst.unexpectedErrorMessage;
}

class OfflineFailure extends Failure {
  @override
  String get message => AppConst.offLineFailureMessage;
}
