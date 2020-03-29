import 'dart:async';

import 'package:dismay_app/models/classes/dismay_screen_data.class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dismay_app/models/classes/error_notification.class.dart';
import 'package:dismay_app/models/classes/ui_notification.class.class.dart';
import 'package:dismay_app/services/service_locator.service.dart';
import 'package:dismay_app/services/shared_preferences.service.dart';
import 'package:dismay_app/utils/helpers.tools.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {
  SharedPreferencesService _prefs;

  bool hasLoaded = false;
  int sessions;
  final int _loads = 0;
  bool smallScreen;
  Offset offset = const Offset(0, 0);
  int currentDash = 0;
  List<DismayScreenData> dissapointments = [];
  Color primaryColor;

  final TextEditingController loginController =
      TextEditingController.fromValue(const TextEditingValue(text: ''));
  final TextEditingController passwordController =
      TextEditingController.fromValue(const TextEditingValue(text: ''));

  final StreamController<ErrorNotification> _errorStreamController =
      StreamController<ErrorNotification>();

  Stream<ErrorNotification> get errorStream => _errorStreamController.stream;

  final StreamController<UiNotification> _noticiationStreamContoller =
      StreamController<UiNotification>();

  final StreamController<ThemeData> themeStreamContoller =
      StreamController<ThemeData>();

  final StreamController<DismayScreenData> reloadStreamController =
      StreamController<DismayScreenData>.broadcast();

  Stream<DismayScreenData> get reloadListner => reloadStreamController.stream;

  DismayScreenData get currentDashData => dissapointments.isNotEmpty
      ? dissapointments[currentDash]
      : DismayScreenData.defaultData(sessions ?? 0);

  MainModel() {
    _prefs = serviceLocator<SharedPreferencesService>();
    loginController.addListener(() => _prefs.setLogIn(loginController.text));
    passwordController
        .addListener(() => _prefs.setPassword(passwordController.text));
    setupPrefs();
  }

  Future<void> setupPrefs() async {
    try {
      await _prefs.initialise();
      sessions = _prefs.getSessions();
      if (_isFirstSession()) {
        _prefs.setScreens([DismayScreenData.defaultData(sessions)]);
        _noticiationStreamContoller.add(ShowIntroUiNotification());
      } else {
        // TODO Remove after a year of publishing new version 29.02.2020
        _prefs.checkForOldSystem();
      }
      loginController.text = _prefs.getLogin();
      passwordController.text = _prefs.getPassword();

      dissapointments = _prefs.getDash();
      _noticiationStreamContoller.add(
        DashViewAddedNotification(index: currentDash),
      );
      sessions++;
      _prefs.setSessions(sessions);
      setTheme();
      notifyListeners();
    } catch (e) {
      _errorStreamController.add(
        ErrorNotification(
            title: "Error",
            message: "There was a problem loading your settings: $e"),
      );
    } finally {
      hasLoaded = true;
    }
    return;
  }

  bool _isFirstSession() => sessions < 1;

  void handlePageLoaded(String value) {
    if (value != "about:blank") {
      _noticiationStreamContoller.add(SetStateUiNotification());
    } else if (_loads > 1) {
      _errorStreamController.add(
          ErrorNotification(title: "Error", message: "The page loaded blank."));
    }
  }

  void iconPicker(
      {@required Function(IconData) onSelect,
      IconData currentIcon = Icons.grid_on}) {
    _noticiationStreamContoller
        .add(PickIconUiNotification(currentIcon, onSelect));
  }

  Stream<UiNotification> get notifcationStream =>
      _noticiationStreamContoller.stream;

  static MainModel of(BuildContext context) =>
      ScopedModel.of<MainModel>(context);

  void dispose() {
    themeStreamContoller.close();
  }

  void dashChanged(int selected) {
    currentDash = selected;
    _noticiationStreamContoller.add(
      DashIndexChangedNotification(index: currentDash),
    );
    setTheme();
    notifyListeners();
  }

  void setTheme() {
    themeStreamContoller.add(ThemeData(
        primarySwatch:
            createMaterialColor(currentDashData?.color ?? Colors.black),
        backgroundColor: Colors.black54));
  }

  Future<void> saveNewDash(DismayScreenData data) async {
    dissapointments ??= [];
    dissapointments.add(data);
    try {
      await _prefs.addDash(data);
      _noticiationStreamContoller.add(
        DashViewAddedNotification(index: currentDash),
      );
      reloadDash(data);
      _noticiationStreamContoller.add(
        DashIndexChangedNotification(index: dissapointments.indexOf(data)),
      );
      _noticiationStreamContoller.add(
        DashIndexChangedNotification(index: dissapointments.indexOf(data)),
      );
      _noticiationStreamContoller.add(
        ShowSnackbarUiNotification('${data.title} added to your dissapointments'),
      );
      notifyListeners();
      return;
    } catch (e) {
      _errorStreamController.add(ErrorNotification(
        title: "Error",
        message: "There was a problem loading your settings: $e",
      ));
    }
  }

  void updateDash(DismayScreenData data) {
    dissapointments ??= [];
    dissapointments = _prefs.updateDash(data).cast<DismayScreenData>();
    _noticiationStreamContoller.add(DashViewsEditedNotification(index: currentDash));
    notifyListeners();
    setTheme();
    reloadDash(data);
  }

  void deleteDash(DismayScreenData data) {
    dissapointments = _prefs.deleteDashById(data.id).cast<DismayScreenData>();
    currentDash = 0; //  Safely goes  to the first dashboard.
    _noticiationStreamContoller.add(DashViewsEditedNotification(index: currentDash));
    notifyListeners();
    setTheme();
  }

  void viewDash(DismayScreenData data) {
    currentDash = dissapointments.indexOf(data);
    _noticiationStreamContoller.add(
      PopToHomeUiNotification(),
    );
    notifyListeners();
    setTheme();
  }

  void reloadDash(DismayScreenData data) {
    reloadStreamController.add(data);
  }

  void handleError(dynamic e, {bool asSnackBar}) {
    if (asSnackBar == true) {
      _noticiationStreamContoller.add(
        ShowSnackbarUiNotification(e as String),
      );
    } else {
      _errorStreamController.add(
        ErrorNotification(
          title: "Error",
          message: "There was a problem loading your settings: $e",
        ),
      );
    }
  }

  void addDash() {
    _noticiationStreamContoller.add(AddDismayNotification());
  }
}
