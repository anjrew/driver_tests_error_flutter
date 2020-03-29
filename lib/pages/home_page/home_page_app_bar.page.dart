import 'package:flutter/material.dart';
import 'package:dismay_app/model/main_model.dart';
import 'package:dismay_app/pages/home_page/options.list.dart';
import 'package:scoped_model/scoped_model.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, MainModel model) => AppBar(
        brightness: Brightness.light, // or use Brightness.dark
        title: Text(model.currentDashData?.title ?? ''),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => openMenu(context),
          )
        ],
      ),
    );
  }

  void openMenu(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("Options"),
          ),
          body: OptionsList(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
