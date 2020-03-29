
import 'package:dart_color_print/dart_color_print.dart';
import 'package:flutter_driver/flutter_driver.dart' as d;
import 'package:flutter_driver/flutter_driver.dart';


Future<void> pressButton({String key, d.FlutterDriver driver}) async {
  assert(key != null);
  assert(driver != null);
  printInfo('Trying to find $key button');
  await driver.waitFor(d.find.byValueKey('$key'));
  printWarning("Found $key button");
  await driver.tap(d.find.byValueKey('$key'));
  printSuccess("Tapped $key button");
  await Future.delayed(Duration(seconds: 1));
}

Future<void> enterTextInField({ String key,  String text,  d. FlutterDriver driver, Duration duration}) async {
  assert(key != null);
  assert(text != null);
  assert(driver != null);

  final SerializableFinder field = d.find.byValueKey('$key');
  printInfo('Trying to find $key textField');
  await driver.waitFor(field).timeout(const Duration(seconds:3));
  printSuccess("Found $key textfield");
  await driver.tap(field);
  printInfo('Entering $text in $key field');
  await driver.enterText("$text");
  await driver.waitFor(d.find.text("$text"));
  printSuccess("Text enterd into $key section");
  await Future.delayed(duration ?? const Duration(milliseconds: 200));
}

Future<void> findByKey({ String key,  String text,  d.FlutterDriver driver,}) async {
  assert(key != null);
  assert(text != null);
  assert(driver != null);

  final SerializableFinder field = d.find.byValueKey('$key');
  printInfo('Trying to find $key');
  await driver.waitFor(field);
  printSuccess("Found $key");
}
