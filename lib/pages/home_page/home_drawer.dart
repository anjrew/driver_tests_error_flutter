import 'package:flutter/material.dart';
import 'package:dismay_app/model/main_model.dart';
import 'package:dismay_app/pages/home_page/options.list.dart';
import 'package:scoped_model/scoped_model.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<MainModel>(
        builder: (BuildContext scopedContext, _, model) => Transform.translate(
          offset: model.offset,
          child: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: const Alignment(-1, 1),
                      child: Text('Options',
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .apply(color: Colors.black))),
                ),
                OptionsList(),
              ],
            ),
          ),
        ),
      );
}
