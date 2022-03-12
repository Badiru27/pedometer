import 'package:pedometer/pedometer.dart';
import 'package:pedometer_test/local_storage.dart';
import 'package:pedometer_test/permission_handler.dart';
import 'package:stacked/stacked.dart';

import 'app/app.locator.dart';

class PedometerService extends BaseViewModel{
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  final _permissionHandlerService = locator<PermissionHandlerService>();
  final _localStorageService = locator<LocalStorageService>();
  late Stream<StepCount> _stepCountStream;

  ///Model code
  
  String _status = '?'; 
  String _steps = '?';
  String get status => _status;
  String get steps => _steps;

  int _start = 200;
  int _time = 0;
  int get time => _time;

  void countStep() async{
    _localStorageService.getSteps().listen((event) {
      _steps = event.toString();
      notifyListeners();
    });

  }
  void init() async{
    await  setUpStepCounter();
    countStep();
  }
  ///
  
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
  int? _todayStep;
  int? get todayStep => _todayStep;
  int? _stepsToBeSaved;
  int? get stepsToBeSaved => _stepsToBeSaved;
  int? _previousStepsTaken;
  int? get previousStepsTaken => _previousStepsTaken;
  String? _where;
  String? get mywhere => _where;


  int? _event;
  int? get myevent => _event;

  void _onStepCount(StepCount event) async{
        final todaySteps =_localStorageService.getPreviousStep(key: event.timeStamp);
        _todayStep = todaySteps;
        _event = event.steps;
        notifyListeners();

        ///Phone reboot
        if(event.steps <= 20){
          _where = 'rebooted';
          _localStorageService.savePreviousStepsTaken(steps: _todayStep!);
          notifyListeners();
        }

        //Nextday

        //Normal even
        await _localStorageService.saveSteps(steps: event.steps, key: event.timeStamp);
        _todayStep = _localStorageService.getPreviousStep(key: event.timeStamp);
        notifyListeners();
  }



  // void _onStepCount(StepCount event) async{
  //       final todaySteps =_localStorageService.getPreviousStep(key: event.timeStamp);
  //       _todayStep = todaySteps;
  //       _event = event.steps;
  //       notifyListeners();

  //       print('=========todayStep: $todaySteps');
  //   //Phone reboot

  //   if(event.steps==0){
  //           // save [previousStepsTaken] to be 0 since it value is been substracted from event.steps
  //    await _localStorageService.savePreviousStepsTaken(steps: 0);
  //    _where ='reboot';
  //    notifyListeners();
  //     if (todaySteps != 0) {
  //     await  _localStorageService.saveTodayStep(steps: todaySteps);

  //       final stepsToBeSaved = todaySteps + event.steps;
  //       print('=========stepTobesave(rebooted): $stepsToBeSaved');
  //       _stepsToBeSaved = stepsToBeSaved;
  //       notifyListeners();
  //     await  _localStorageService.saveSteps(
  //           steps: stepsToBeSaved, key: event.timeStamp);
  //       return;
  //     }else{
  //     await  _localStorageService.savePreviousStepsTaken(steps: 0);
  //     }
  //   await  _localStorageService.saveSteps(steps: event.steps, key: event.timeStamp);
  //     return;
  //   }else{
  //      //Nextday
  //       if (todaySteps == 0) {
  //     // subtract 1 from the event step since the first taken step is also part of
  //     // the emitted step
  //    await _localStorageService.savePreviousStepsTaken(steps: event.steps - 1);
  //   } }


  //   //When nothing happens
  //   final previousStepsTaken =  _localStorageService.getPreviousStepsTaken();
  //   _previousStepsTaken = previousStepsTaken;
  //   final int stepsToBeSaved = (event.steps + todaySteps- previousStepsTaken).toInt();
  //   _stepsToBeSaved = stepsToBeSaved;
  //   notifyListeners();
  //   print('=========previousStepsTaken: $previousStepsTaken');
  //   print('=========stepsToBeSaved: $stepsToBeSaved');

  //   await _localStorageService.saveSteps(steps: stepsToBeSaved, key: event.timeStamp);
  // }



   void onPedestrianStatusChanged(PedestrianStatus event)  {
    // print(event);
    _status= event.status;
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
    _stepCountStream.listen(_onStepCount).onError(onStepCountError);
  }
}
