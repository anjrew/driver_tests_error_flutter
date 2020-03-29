import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dismay_app/models/classes/dismay_screen_data.class.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dismay_app/utils/validators.dart';
part 'add_dismay_page_event.dart';
part 'add_dismay_page_state.dart';

class AddDismayPageBloc extends Bloc<AddDismayPageEvent, AddDismayPageState> {
  final int _id;
  double _currentPage;
  String _title;
  IconData _icon;
  Color _color;
  Color _iconColor;
  String _url;

  AddDismayPageState get _currentState => AddDismayPageState(
      id: _id,
      color: _color,
      page: _currentPage,
      title: _title,
      icon: _icon,
      url: _url,
      iconColor: _iconColor);

  AddDismayPageBloc(
      {@required int id,
      double page = 0,
      Color color = Colors.orange,
      String title = '',
      IconData icon = Icons.add_circle_outline,
      Color iconColor = Colors.white,
      String url = ''})
      : _id = id,
        _currentPage = page,
        _title = title,
        _icon = icon,
        _color = color,
        _iconColor = iconColor,
        _url = url,
        assert(id != null, 'The id is null in the add page bloc');

  static AddDismayPageBloc from({@required DismayScreenData data}) {
    return AddDismayPageBloc(
        id: data.id,
        page: 0,
        color: data.color,
        title: data.title,
        icon: data.icon,
        iconColor: data.iconColor,
        url: data.url);
  }

  @override
  AddDismayPageState get initialState => _currentState;

  @override
  Stream<AddDismayPageState> mapEventToState(
    AddDismayPageEvent event,
  ) async* {
    if (event is NextPageEvent) {
      final isUrl = isValidURL(_currentState.url);
      final isIpAddress = isIPAddress(_currentState.url);

      if (event.currentPageIndex == 2 && !isUrl && !isIpAddress) {
        yield AddDismayPageErrorState.from(
            state, "Needs to be a valid URL including relevant protocol or IP");
      } else {
        _currentPage++;
        yield NextPageState.from(_currentState, page: _currentPage);
      }
    }
    if (event is GoBackAddDismayPageEvent) {
      _currentPage--;
      yield GoBackState.from(
        _currentState,
        page: _currentPage,
      );
    }
    if (event is TitleInputEvent) {
      _title = event.title;
      yield AddDismayPageState.from(_currentState);
    }
    if (event is IconSelectedEvent) {
      _icon = event.icon;
      yield AddDismayPageState.from(_currentState);
    }
    if (event is SelectIconColorEvent) {
      _iconColor = event.color;
      yield AddDismayPageState.from(_currentState);
    }
    if (event is SelectIconEvent) {
      yield SelectIconState.from(_currentState);
    }
    if (event is IconSelectedEvent) {
      _icon = event.icon;
      yield InputTitleState.from(_currentState);
    }
    if (event is ColorSelectedEvent) {
      _color = event.color;
      yield AddDismayPageState.from(_currentState);
    }
    if (event is UrlInputEvent) {
      _url = event.url;
      yield AddDismayPageState.from(_currentState);
    }
    if (event is TryToValidateDashEvent) {
      if (!isValidURL(_currentState.url) && !isIPAddress(_currentState.url)) {
        yield AddDismayPageErrorState.from(
            state, "Needs to be a valid URL including relevant protocol or IP");
      } else {
        yield TryToValidateDashState.from(_currentState);
      }
    }
    if (event is SubmitAddDismayPageEvent) {
      yield SaveDashState.from(_currentState);
    }
  }
}
