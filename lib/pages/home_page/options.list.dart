import 'package:dismay_app/model/main_model.dart';
import 'package:dismay_app/models/classes/dismay_screen_data.class.dart';
import 'package:dismay_app/pages/add_grafana_page/add_dismay_page_screen_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dismay_app/resources/constants/colors.consts.dart';
import 'package:dismay_app/utils/helpers.tools.dart';
import 'package:scoped_model/scoped_model.dart';

class OptionsList extends StatefulWidget {
  @override
  _OptionsListState createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList>
    with TickerProviderStateMixin {
  final EdgeInsets padding = const EdgeInsets.all(10);
  final int bgintensity = 40;
  AnimationController animationController;
  Animation<double> animation;
  double screenHeight;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => screenHeight = MediaQuery.of(context).size.height);
    super.initState();
  }

  @override
  Widget build(_) => ScopedModelDescendant<MainModel>(
        builder: (context, __, MainModel model) => Material(
          color: Color.fromARGB(250, bgintensity, bgintensity, bgintensity),
          child: ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              Padding(
                padding: padding,
                child: TextField(
                  style: textStyleWhite,
                  keyboardAppearance: Brightness.light,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  scrollPadding: padding,
                  decoration: InputDecoration(
                      suffixIcon: Builder(                        
                        builder: (contextWithScaffold) {
                          return MaterialButton(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: model.loginController.text));
                              removeKeyboard(contextWithScaffold);
                              Scaffold.of(contextWithScaffold).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Login copied',
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.content_copy,
                              color: Colors.white,
                            ),
                          );
                        }
                      ),
                      labelText: "Login email/username",
                      labelStyle:
                          TextStyle(color: Colors.white.withAlpha(200))),
                  controller: model.loginController,
                ),
              ),
              Padding(
                padding: padding,
                child: TextField(
                  style: textStyleWhite,
                  keyboardAppearance: Brightness.light,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  maxLines: 1,
                  scrollPadding: padding,
                  decoration: InputDecoration(
                      suffixIcon: Builder(
                        builder: (contextWithScaffold) {
                          return MaterialButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: model.passwordController.text),
                              );
                              removeKeyboard(contextWithScaffold);
                              Scaffold.of(contextWithScaffold).showSnackBar(
                                const SnackBar(
                                  content: Text('Password copied'),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.content_copy,
                              color: Colors.white,
                            ),
                          );
                        }
                      ),
                      labelText: "Password",
                      labelStyle:
                          TextStyle(color: Colors.white.withAlpha(200))),
                  controller: model.passwordController,
                ),
              ),
              ...?MainModel.of(context)
                  .dissapointments
                  ?.map(
                    (data) => Slidable(
                      actionPane: const SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Reload',
                          color: Colors.grey,
                          icon: Icons.refresh,
                          onTap: () => debugPrint("Reload"),
                        )
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => model.deleteDash(data),
                        ),
                      ],
                      child: ListTile(
                        leading: Icon(
                          data.icon,
                          color: data.iconColor,
                        ),
                        title: Text(
                          data.title ?? 'ERROR: No title  given',
                          style: textStyleWhite,
                        ),
                        onTap: () async {
                          final value = await Navigator.of(context).push(
                            AddDismayPageScreen.route(data: data),
                          );
                          if (value is DismayScreenData) {
                            MainModel.of(context).updateDash(value);
                          }
                        },
                      ),
                    ),
                  )
                  ?.toList(),
              if (model.dissapointments.length < 3)
                IconButton(
                    iconSize: 50,
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final value = await Navigator.of(context)
                          .push(AddDismayPageScreen.route());
                      if (value is DismayScreenData) {
                        MainModel.of(context).saveNewDash(value);
                      }
                    }),
            ],
          ),
        ),
      );
}
