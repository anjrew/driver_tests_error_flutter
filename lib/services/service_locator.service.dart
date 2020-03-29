import 'package:get_it/get_it.dart';
import 'package:dismay_app/services/crashlytics.service.dart';
import 'package:dismay_app/services/shared_preferences.service.dart';

GetIt serviceLocator = GetIt.instance;

void registerServices(){
	serviceLocator.registerSingleton<CrashlyticsService>(CrashlyticsService());
	serviceLocator.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
}