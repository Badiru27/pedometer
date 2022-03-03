import 'package:pedometer/pedometer.dart';
import 'package:pedometer_test/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

import 'app/app.locator.dart';

class PedometerViewModel extends BaseViewModel {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
    final _permissionHandlerService = locator<PermissionHandlerService>();
  String _status = '?'; 
  String _steps = '?';
  String get status => _status;
  String get steps => _steps;

  int _start = 200;
  int _time = 0;
  int get time => _time;

  void timer(){
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_start == 0){      
        _start = 200;
        notifyListeners();
      }
      else{
        _time = _start--;
        notifyListeners();
      }
    });
  }

  void init() {
    setUpStepCounter();
   // timer();
  }


  Future<void> setUpStepCounter() async {
  
    if (await _permissionHandlerService.isActivityRecognitionStatusIsDenied) {
      await _permissionHandlerService.requestForActivityRecognitionPermission();
    }

    if (await _permissionHandlerService
        .isActivityRecognitionStatusIsRestricted) {
      await _permissionHandlerService.requestForActivityRecognitionPermission();
    }
    initPlatformState();
  }


  void onStepCount(StepCount event) {
    _steps = event.steps.toString();
   // print(event);
    print('============${event.timeStamp.toString()}');
    print(event.steps.toString());
    notifyListeners();
  }
  
   // Upon device reboot, pedometer resets. 
   //When this happens, the saved counter must be reset as well.

    // When the day changes, reset the daily steps count and 
    //Update the last day saved as the day changes.


  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
    print(event);
    notifyListeners();
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    print(_status);
     _status = 'Pedestrian Status not available';
     notifyListeners();
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
     _steps = 'Step Count not available';
     notifyListeners();
  }


  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

  }
}
