import 'package:dart_color_print/dart_color_print.dart';
import 'package:dismay_app/models/classes/dismay_screen_data.class.dart';
import 'package:dismay_app/pages/add_grafana_page/add_dismay_page_screen_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dismay_app/components/overlay.dart';
import 'package:dismay_app/model/main_model.dart';
import 'package:dismay_app/models/classes/error_notification.class.dart';
import 'package:dismay_app/models/classes/ui_notification.class.class.dart';
import 'package:dismay_app/pages/home_page/home_page_app_bar.page.dart';
import 'package:dismay_app/resources/constants/colors.consts.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MainModel.of(context).errorStream.listen(
            (ErrorNotification error) => showErrorDiolog(context, error: error),
          );
      MainModel.of(context).notifcationStream.listen(
            (UiNotification object) => handleNotification(object),
          );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => MainModel.of(context)
        .smallScreen = MediaQuery.of(context).size.height < 600);
    setUpTabController(0);
    super.initState();
  }

  void setUpTabController(int index) {
    _tabController = TabController(
        vsync: this,
        initialIndex: index,
        length: MainModel.of(context).dissapointments?.length);
  }

  /// MAIN BUILD OF HOME PAGE
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<MainModel>(
        rebuildOnChange: true,
        builder: (_, Widget child, MainModel model) => Scaffold(
          key: _scaffoldKey,
          appBar: child as MainAppBar,
          body: model.hasLoaded
              ? model.dissapointments.isNotEmpty
                  ? buildDashBoards(model)
                  : buildAddDismayboardButton(context)
              : const Center(
                  child: CircularProgressIndicator(
                    key: ValueKey('home_progress_indicator'),
                  ),
                ),
          bottomNavigationBar: model.dissapointments != null
              ? model.dissapointments.length > 1
                  ? Container(
                      color: Colors.black,
                      child: BottomNavigationBar(
                        // backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                        backgroundColor: Colors.black,
                        currentIndex: model.currentDash ?? 0,
                        items: model.dissapointments
                            .map(
                              (data) => BottomNavigationBarItem(
                                icon: Icon(
                                  data.icon ?? Icons.error,
                                  color: data.iconColor?.withAlpha(100),
                                ),
                                activeIcon: Icon(
                                  data.icon ?? Icons.error,
                                  color: data.iconColor,
                                ),
                                title: Text(
                                  data.title ?? 'ERROR: NO TITLE',
                                  style: textStyleWhite,
                                ),
                              ),
                            )
                            .toList(),
                        onTap: model.dashChanged,
                      ),
                    )
                  : null
              : null,
        ),
        child: MainAppBar(),
      );

  Center buildAddDismayboardButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => MainModel.of(context).addDash(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.add_circle,
              size: 50,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Add dash',
                style: textStyleWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDashBoards(MainModel model) {
    return model.dissapointments.length == _tabController.length
        ? TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              ...?model.dissapointments.map(
                (data) => _DashView(data: data),
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  void showErrorDiolog(BuildContext oldContext,
      {ErrorNotification error, Function() okPressed}) {
    showDialog(
        context: oldContext,
        builder: (BuildContext context) {
          const EdgeInsetsGeometry padding = EdgeInsets.all(10);
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              error.title,
              style: textStyleWhite,
            ),
            titlePadding: padding,
            content: Text(
              error.message,
              style: textStyleWhite,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: okPressed ?? () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: textStyleWhite,
                ),
              )
            ],
          );
        });
  }

  Future<dynamic> handleNotification(UiNotification notification) async {
    if (notification is SetStateUiNotification) {
      setState(() {});
      return;
    }

    if (notification is ShowIntroUiNotification) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const EdgeInsetsGeometry padding = EdgeInsets.all(10);
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Welcome',
              style: textStyleWhite,
            ),
            titlePadding: padding,
            content: const Text(
              'If this is your first time, you can set your own dismay URL and other details in the options menu.',
              style: textStyleWhite,
            ),
            actions: <Widget>[
              MaterialButton(
                key: const ValueKey('welcome_diolog_key'),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: textStyleWhite,
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    if (notification is DashIndexChangedNotification) {
      _tabController.animateTo(notification.index);
      return;
    }

    if (notification is DashViewAddedNotification) {
      setUpTabController(notification.index);
      return;
    }

    if (notification is DashViewsEditedNotification) {
      setUpTabController(notification.index);
      return;
    }

    if (notification is PickIconUiNotification) {
      final IconData icon = await FlutterIconPicker.showIconPicker(context,
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
          noResultsText: 'No results for:');

      notification.callBack(icon);
      return;
    }

    if (notification is AddDismayNotification) {
      final value = await Navigator.of(context).push(
        AddDismayPageScreen.route(),
      );
      if (value is DismayScreenData) {
        MainModel.of(context).saveNewDash(value);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
      return;
    }

    if (notification is ShowSnackbarUiNotification) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          key: const ValueKey('notificationSnackbar'),
          content: Text(notification.message),
        ),
      );
      return;
    }

    printError("No matching case in on screen lister");
  }
}

class _DashView extends StatefulWidget {
  final DismayScreenData data;
  const _DashView({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  __DashViewState createState() => __DashViewState();
}

class __DashViewState extends State<_DashView>
    with AutomaticKeepAliveClientMixin<_DashView> {
  InAppWebViewController webViewController;
  bool _hasLoaded = false;
  String url;

  @override
  void initState() {
    super.initState();
    url = widget.data.url;
    MainModel.of(context).reloadListner.listen((incomingData) {
      // Listens on the stream  and checks the incoming data is relevant to this
      // dash view. If so it updates
      if (widget.data.id == incomingData.id) {
        url = incomingData.url;
        load(url);
      }
    });
    load(url);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        InAppWebView(
          initialUrl: url,
          initialHeaders: {},
          initialOptions: InAppWebViewWidgetOptions(
            inAppWebViewOptions: InAppWebViewOptions(
              debuggingEnabled: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
            printInfo('Webview loaded $url');
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            printInfo('Loading url $url');
            _hasLoaded = false;
          },
          onLoadStop: (InAppWebViewController controller, String url) {
            printSuccess('Loaded url $url');
            setState(() => _hasLoaded = true);
          },
          onReceivedServerTrustAuthRequest: (InAppWebViewController controller,
              ServerTrustChallenge challenge) async {
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
        ),
        DarkOverlay(show: !_hasLoaded),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  void setupWebview(InAppWebViewController controller) {
    webViewController = webViewController;
    load(url);
  }

  void load(String url) {
    if (webViewController != null) {
      webViewController.loadUrl(url: url);
    }
  }
}
