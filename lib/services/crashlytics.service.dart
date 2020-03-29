import 'package:flutter/foundation.dart';
import 'package:dismay_app/secrets/secret_keys.dart';
import 'package:sentry/sentry.dart';

class CrashlyticsService {
  final SentryClient sentry = SentryClient(dsn: sentryDsn);

  CrashlyticsService() {
    // Set `enableInDevMode` to true to see reports while in debug mode
    // This is only to be used for confirming that reports are being
    // submitted as expected. It is not intended to be used for everyday
    // development.

    // Pass all uncaught errors from the framework to Crashlytics.
    // Crashlytics.instance.crash();

    FlutterError.onError = (FlutterErrorDetails details, {bool forceReport = false}) {
      try {
        sentry.captureException(
          exception: details.exception,
          stackTrace: details.stack,
        );
      } catch (e) {
        debugPrint('Sending report to sentry.io failed: $e');
      } finally {
        // Also use Flutter's pretty error logging to the device's console.
        FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
      }
    };
  }
}
