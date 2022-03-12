// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../local_storage.dart';
import '../pedometer_service.dart';
import '../pedometer_viewmodel.dart';
import '../permission_handler.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => PedometerViewModel());
  locator.registerLazySingleton(() => PermissionHandlerService());
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => PedometerService());
}
