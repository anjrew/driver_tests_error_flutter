import 'package:dismay_app/models/classes/dismay_screen_data.class.dart';
import 'package:dismay_app/pages/add_grafana_page/add_dismay_page_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

void addDashController(BuildContext context, AddDismayPageState state) {
  // const Duration pageDuration = Duration(milliseconds: 200);
  // const Curve pageCurve = Curves.easeInOut;
  if (state is SelectIconState) {
    FlutterIconPicker.showIconPicker(context,
            iconSize: 40,
            iconPickerShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text('Pick an icon',
                style: TextStyle(fontWeight: FontWeight.bold)),
            closeChild: const Text(
              'Close',
              textScaleFactor: 1.25,
            ),
            searchHintText: 'Search icon...',
            noResultsText: 'No results for:')
        .then((IconData icon) {
      if (icon != null) {
        BlocProvider.of<AddDismayPageBloc>(context).add(
          IconSelectedEvent(icon),
        );
      }
    });
  }

  // TODO: if (state is NextPageState) {
  //   _pageController.nextPage(duration: pageDuration, curve: pageCurve);
  // }

  // if (state is GoBackState) {
  //   if (state.page < 0.0) {
  //     Navigator.pop(context);
  //   } else {
  //     _pageController.previousPage(duration: pageDuration, curve: pageCurve);
  //   }
  // }

  if (state is NextPageState || state is GoBackState) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  if (state is SaveDashState) {
    Navigator.of(context).pop(DismayScreenData(
        id: state.id,
        url: state.url,
        title: state.url,
        color: state.color,
        icon: state.icon,
        iconColor: state.iconColor));
  }
}
