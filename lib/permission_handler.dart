import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  final _activityRecognitionStatus = Permission.activityRecognition.status;

  /// This function returns the boolean value of [_activityRecognitionStatus] is granted state
  Future<bool> get isActivityRecognitionStatusIsGranted async =>
      await _activityRecognitionStatus.isGranted;

  /// This function returns the boolean value of [_activityRecognitionStatus] is restricted state
  Future<bool> get isActivityRecognitionStatusIsRestricted async =>
      await _activityRecognitionStatus.isRestricted;

  /// This function returns the boolean value of [_activityRecognitionStatus] is denied state
  Future<bool> get isActivityRecognitionStatusIsDenied async =>
      await _activityRecognitionStatus.isDenied;

  /// This function request for Activity Recognition permission from the user.
  Future<void> requestForActivityRecognitionPermission() async =>
      await Permission.activityRecognition.request();
}
