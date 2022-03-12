
import 'package:pedometer_test/local_storage.dart';
import 'package:pedometer_test/pedometer_service.dart';
import 'package:pedometer_test/pedometer_viewmodel.dart';
import 'package:pedometer_test/permission_handler.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [

], dependencies: [
  LazySingleton(classType: SnackbarService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: PedometerViewModel),
  LazySingleton(classType: PermissionHandlerService),
  LazySingleton(classType: LocalStorageService),
  LazySingleton(classType: PedometerService),
])
class AppSetup {}
