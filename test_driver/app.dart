import 'package:flutter_driver/driver_extension.dart';

import 'package:dismay_app/main.dart' as app;
import 'package:dismay_app/services/service_locator.service.dart' as sl;

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();
  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  sl.registerServices();
  app.main();
}