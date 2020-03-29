// Imports the Flutter Driver API.
import 'dart:async';

import 'package:dart_color_print/dart_color_print.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'driver_helper_functions.dart';

void main() {
  StreamSubscription streamSubscription;
  group('Check app renders welcome screen', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    // final homeProgressIndicator = find.byValueKey('home_progress_indicator');
    // final welcomeDiologButtonKey = find.byValueKey('welcome_diolog_key');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect(
          printCommunication: true, logCommunicationToFile: true);

      streamSubscription = driver.serviceClient.onIsolateRunnable
          .asBroadcastStream()
          .listen((isolateRef) {
        printSuccess(
            'Resuming isolate: ${isolateRef.numberAsString}:${isolateRef.name}');
        isolateRef.resume();
      });
    });

    test('Press ok on the welcome diolog', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      pressButton(key: 'welcome_diolog_key', driver: driver);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) await driver.close();
      if (streamSubscription != null) streamSubscription.cancel();
    });
  });
}
