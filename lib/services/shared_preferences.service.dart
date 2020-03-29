import 'dart:convert';
import 'dart:ui';

import 'package:dismay_app/models/classes/dismay_screen_data.class.dart';
import 'package:flutter/material.dart';

import 'package:dismay_app/utils/helpers.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dismay_app/resources/constants/shared_preference_keys.consts.dart'
    as sp_keys;

class SharedPreferencesService {
  SharedPreferences _prefs;

  Future<void> initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Gets a list of the the saved dashboards
  List<DismayScreenData> getDash() {
    final String screenData = _prefs.getString(sp_keys.screenData);
    if (screenData != null) {
      final screens = jsonDecode(screenData) as List<dynamic>;
      final List<Map<String, dynamic>> casts =
          List<Map<String, dynamic>>.from(screens);
      return casts.map((data) => DismayScreenData.fromMap(data)).toList();
    } else {
      return [];
    }
  }

  Future<bool> setScreens(List<DismayScreenData> data) {
    assert(data != null, "setScreens data was null");

    final List<Map<String, dynamic>> map =
        data.map((data) => data.toMap()).toList();
    final String encoded = json.encode(map);
    return _prefs.setString(sp_keys.screenData, encoded);
  }

  /// Adds a dashboard and returns the new saved value
  Future<List<DismayScreenData>> addDash(DismayScreenData data) async{
    assert(data != null, "addDash data was null");

    final List<DismayScreenData> screens = getDash() ?? [];
    screens.add(data);
    await setScreens(screens);
    return screens;
  }

  /// Updates a dashboard and returns the new saved value
  List<DismayScreenData> updateDash(DismayScreenData data){
    assert(data != null, "updateDash data was null");
    final List<DismayScreenData> dashs = getDash() ?? [];
    final int currentIndex = dashs.indexWhere((dash)=> dash.id == data.id);
    dashs[currentIndex] = data;
    setScreens(dashs);
    return dashs;
  }

  /// Deletes a dashboard by id and returns the new saved value
  List<DismayScreenData> deleteDashById(int id) {
    final List<DismayScreenData> dashs = getDash() ?? [];
    dashs.removeWhere((screenData) => screenData.id == id);
    setScreens(dashs);
    return dashs;
  }

  void setLogIn(String text) {
    _prefs.setString(sp_keys.login, text);
  }

  void setPassword(String text) {
    _prefs.setString(sp_keys.password, text);
  }

  void setSessions(int _sessions) {
    _prefs.setInt(sp_keys.sessions, _sessions);
  }

  int getSessions() {
    if (_prefs.containsKey(sp_keys.sessions)) {
      return _prefs.getInt(sp_keys.sessions) ?? 0;
    } else {
      return 0;
    }
  }

  String getLogin() {
    return _prefs.getString(sp_keys.login);
  }

  String getPassword() {
    return _prefs.getString(sp_keys.password);
  }

  /// Old methods

  // TODO Remove after a year of publishing new version 29.02.2020
  void checkForOldSystem() {
    final String title = _prefs.getString(sp_keys.title);
    final String url = _prefs.getString(sp_keys.url);
    final int color = _prefs.getInt(sp_keys.primeColor);
    final int sessions = _prefs.getInt(sp_keys.sessions);

    /// No old data
    if (title != null || url != null || color != null) {
      final data = DismayScreenData(
        id: idGenerator(sessions),
        title: title ?? 'DriverDismay',
        url: url ?? "https://www.dismay.com",
        color: _defaultColor(color),
        icon: Icons.dashboard,
        iconColor: _defaultColor(color),
      );
      addDash(data);
    }
  }

  Color _defaultColor(int color) =>
      color != null ? Color(color) : Colors.orange;

  String getTitle() {
    return _prefs.getString(sp_keys.title) ?? 'DriverDismay';
  }

  String getUrl() {
    return _prefs.getString(sp_keys.url) ?? 'https://www.dismay.com';
  }

  int getColor() {
    return _prefs.getInt(sp_keys.primeColor) ?? 0;
  }
}
