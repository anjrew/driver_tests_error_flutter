import 'package:flutter/material.dart';

abstract class UiNotification {}

class ErrorUiNotification extends UiNotification {}

class ShowDiologUiNotification extends UiNotification {}

class ShowIntroUiNotification extends UiNotification {}

class ShowSnackbarUiNotification extends UiNotification {
  String message;
  ShowSnackbarUiNotification(this.message);
}

class SetStateUiNotification extends UiNotification {}

class PopToHomeUiNotification extends UiNotification {}

class DashIndexChangedNotification extends UiNotification {
  final int index;
  DashIndexChangedNotification({@required this.index});
}

class DashViewAddedNotification extends UiNotification {
  final int index;
  DashViewAddedNotification({@required this.index});
}

class DashViewsEditedNotification extends UiNotification {
  final int index;
  DashViewsEditedNotification({@required this.index});
}

class AddDismayNotification extends UiNotification {}

class PickIconUiNotification extends UiNotification {
  IconData currentIcon;
  Function(IconData) callBack;
  PickIconUiNotification(this.currentIcon, this.callBack);
}
