import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dismay_app/model/main_model.dart';
import 'package:dismay_app/pages/home_page/home.dart';
import 'package:dismay_app/resources/constants/colors.consts.dart';
import 'package:dismay_app/utils/helpers.tools.dart';
import 'package:scoped_model/scoped_model.dart';
import 'services/service_locator.service.dart' as sl;

void main() {
  sl.registerServices();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarBrightness:
          Brightness.light // Dark == white status bar -- for IOS.
      ));
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  MainModel model;

  @override
  void initState() {
    super.initState();
    model = MainModel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: StreamBuilder<ThemeData>(
          initialData: ThemeData(
              primarySwatch: createMaterialColor(
                  model.currentDashData?.color as Color ?? Colors.black),
              backgroundColor: Colors.grey,
              scaffoldBackgroundColor: Colors.grey),
          stream: model.themeStreamContoller.stream,
          builder: (context, snapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'dismay Dash',
              theme: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: textStyleWhite,
                  helperStyle: textStyleWhite,
                  errorStyle: TextStyle(color: Colors.red),
                  filled: true,
                ),
                // iconTheme: IconThemeData(color: Colors.white),
                primarySwatch: createMaterialColor(
                    model.currentDashData?.color as Color ?? Colors.black),
                backgroundColor:
                    snapshot.data.backgroundColor ?? Colors.black38,
                scaffoldBackgroundColor: Colors.black38,
                textTheme: TextTheme(
                  body1: textStyleWhite,
                  body2: textStyleWhite,
                  display1: TextStyle(color: model.primaryColor),
                  display2: TextStyle(color: model.primaryColor),
                  display3: TextStyle(color: model.primaryColor),
                  display4: TextStyle(color: model.primaryColor),
                  subhead: TextStyle(color: model.primaryColor),
                ),
                hintColor: Colors.white,
              ),
              home: HomePage(),
            );
          }),
    );
  }
}
