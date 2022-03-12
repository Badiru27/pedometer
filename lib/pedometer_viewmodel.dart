import 'package:pedometer_test/local_storage.dart';
import 'package:pedometer_test/pedometer_service.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

import 'app/app.locator.dart';

class PedometerViewModel extends BaseViewModel {

  final _pedometerService = locator<PedometerService>();
    final _localStorageService = locator<LocalStorageService>();

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

  void countStep() async{
    _localStorageService.getSteps().listen((event) {
      _steps = event.toString();
      notifyListeners();
    });

  }
  void init() async{
    await  _pedometerService.setUpStepCounter();
    countStep();
  }



}
