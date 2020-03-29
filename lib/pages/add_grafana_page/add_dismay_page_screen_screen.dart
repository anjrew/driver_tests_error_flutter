import 'package:dismay_app/models/classes/dismay_screen_data.class.dart';
import 'package:dismay_app/pages/add_grafana_page/add_dismay_page_bloc.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:dismay_app/components/color_picker.widget.dart';
import 'package:dismay_app/model/main_model.dart';
import 'package:dismay_app/resources/constants/colors.consts.dart';
import 'package:dismay_app/utils/helpers.tools.dart';
import 'package:dismay_app/utils/validators.dart';

class AddDismayPageScreen extends StatefulWidget {
  final DismayScreenData data;

  const AddDismayPageScreen({Key key, this.data}) : super(key: key);

  static MaterialPageRoute route({DismayScreenData data}) => MaterialPageRoute(
        builder: (_) => AddDismayPageScreen(data: data),
      );

  @override
  AddDismayPageScreenState createState() => AddDismayPageScreenState();
}

class AddDismayPageScreenState extends State<AddDismayPageScreen> {
  final _formKey = GlobalKey<FormState>();
  AddDismayPageBloc _bloc;
  PageController _pageController;
  Duration pageDuration = const Duration(milliseconds: 200);
  Curve pageCurve = Curves.easeInOut;
  double maxWidth = 200;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _bloc = AddDismayPageBloc.from(data: widget.data);
    } else {
      _bloc = AddDismayPageBloc(id: idGenerator(MainModel.of(context).sessions));
    }
    _pageController = PageController();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<AddDismayPageBloc, AddDismayPageState>(
        condition: (o,n) => o.props != n.props || n is AddDismayPageErrorState,
        bloc: _bloc,
        listener: (listenerContext, state) async {
          if (state is SelectIconState) {
            final IconData icon = await FlutterIconPicker.showIconPicker(
                listenerContext,
                iconSize: 40,
                iconPickerShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Text('Pick an icon',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                closeChild: const Text(
                  'Close',
                  textScaleFactor: 1.25,
                ),
                searchHintText: 'Search icon...',
                noResultsText: 'No results for:');
            if (icon != null) {
              _bloc.add(
                IconSelectedEvent(icon),
              );
            }
          }

          if (state is NextPageState) {
            _pageController.nextPage(duration: pageDuration, curve: pageCurve);
          }

          if (state is GoBackState) {
            if (state.page < 0.0) {
              Navigator.pop(context);
            } else {
              _pageController.previousPage(
                  duration: pageDuration, curve: pageCurve);
            }
          }

          if (state is NextPageState || state is GoBackState) {
            removeKeyboard(context);
          }

          if (state is TryToValidateDashState) {
            if (_formKey.currentState.validate()) {
              // If the form is valid, display a Snackbar.
              _bloc.add(const SubmitAddDismayPageEvent());
            } else {}
          }

          if (state is SaveDashState) {
            Navigator.of(context).pop(
              DismayScreenData(
                  id: state.id,
                  url: state.url,
                  title: state.title,
                  color: state.color,
                  icon: state.icon,
                  iconColor: state.iconColor),
            );
          }

          if (state is AddDismayPageErrorState) {
            MainModel.of(context).handleError(state.errorMessage);
          }
        },
        child: BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
          bloc: _bloc,
          builder: (
            BuildContext context,
            AddDismayPageState state,
          ) {
            final formSections = [
              _TitlePageAddDismayInput(bloc: _bloc),
              _DashColorPickerAddDismayInput(bloc: _bloc),
              _UrlInputAddDismayInput(bloc: _bloc),
              _IconSelectionAddDismayInput(bloc: _bloc),
              _IconColorSelectorAddDismay(bloc: _bloc),
              const _ConfirmationSectionAddDismay(),
            ];
            return Theme(
              data: Theme.of(context).copyWith(
                buttonTheme: ButtonThemeData(buttonColor: state.color),
                buttonColor: state.color,
                primaryColor: state.color,
                accentColor: state.color,
              ),
              child: Scaffold(
                backgroundColor: Colors.black87,
                appBar: addDashAppBar(
                  title: state.title,
                  back: () => _bloc.add(
                    const GoBackAddDismayPageEvent(),
                  ),
                  pageDuration: pageDuration,
                  pageCurve: pageCurve,
                  showDismiss: state.page > 0,
                ),
                body: Form(
                  key: _formKey,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: formSections,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DotsIndicator(
                          dotsCount: formSections.length ?? 0,
                          position: state.page < 0 ? 0 : state.page,
                          decorator: DotsDecorator(
                            color: state.color != null
                                ? state.color.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                            activeColor: state.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar addDashAppBar(
      {@required Duration pageDuration,
      @required Curve pageCurve,
      @required Function() back,
      String title,
      bool showDismiss}) {
    return AppBar(
      title: Text(title),
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: back),
      actions: showDismiss
          ? [
              IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () => Navigator.of(context).pop())
            ]
          : null,
    );
  }
}

class _ConfirmationSectionAddDismay extends StatelessWidget {
  const _ConfirmationSectionAddDismay({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
        condition: (olds, newS) => olds.props != newS.props,
        bloc: BlocProvider.of<AddDismayPageBloc>(context),
        builder: (
          BuildContext context,
          AddDismayPageState state,
        ) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.title ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .apply(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    state.icon,
                    size: 80,
                    color: state.iconColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.url ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .apply(color: Colors.white),
                  ),
                ),
                CupertinoButton(
                  onPressed: () => BlocProvider.of<AddDismayPageBloc>(context)
                      .add(const TryToValidateDashEvent()),
                  child: Text(
                    'Save',
                    style: primaryColorTextStyle(context),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class _IconColorSelectorAddDismay extends StatelessWidget {
  const _IconColorSelectorAddDismay({
    Key key,
    @required AddDismayPageBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final AddDismayPageBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
      condition: (olds, newS) => olds.iconColor != newS.iconColor,
      bloc: _bloc,
      builder: (
        BuildContext context,
        AddDismayPageState state,
      ) {
        return Center(
          child: ListView(
            children: [
              Container(height: 50),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                child: Hero(
                  tag: Key('icon-hero-${state.title}-${state.url}'),
                  child: Icon(
                    state.icon,
                    size: 80,
                    color: state.iconColor ?? Colors.white,
                  ),
                ),
              ),
              ColorPicker(
                key: Key(state.iconColor.toString()),
                title: 'Icon color',
                current: state.iconColor,
                onPick: (color) => _bloc.add(
                  SelectIconColorEvent(color),
                ),
                padding: null,
              ),
              const _AdddismayNextButton(),
            ],
          ),
        );
      },
    );
  }
}

class _IconSelectionAddDismayInput extends StatelessWidget {
  const _IconSelectionAddDismayInput({
    Key key,
    @required AddDismayPageBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final AddDismayPageBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
        condition: (olds, newS) => olds.icon != newS.icon,
        bloc: _bloc,
        builder: (
          BuildContext context,
          AddDismayPageState state,
        ) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Choose an Icon for the Dashboard"),
                IconButton(
                  iconSize: 80,
                  icon: Hero(
                    tag: Key('icon-hero-${state.title}-${state.url}'),
                    child: Icon(
                      state.icon,
                      color: state.iconColor ?? Colors.white,
                    ),
                  ),
                  onPressed: () => _bloc.add(const SelectIconEvent()),
                ),
                const _AdddismayNextButton(),
              ],
            ),
          );
        });
  }
}

class _AdddismayNextButton extends StatelessWidget {
  const _AdddismayNextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
        condition: (olds, newS) => olds.url != newS.url,
        bloc: BlocProvider.of<AddDismayPageBloc>(context),
        builder: (
          BuildContext context,
          AddDismayPageState state,
        ) {
          return CupertinoButton(
            onPressed: () => BlocProvider.of<AddDismayPageBloc>(context)
                .add(NextPageEvent(state.page)),
            child: Text(
              'Next',
              style: primaryColorTextStyle(context),
            ),
          );
        });
  }
}

class _UrlInputAddDismayInput extends StatelessWidget {
  final AddDismayPageBloc _bloc;

  const _UrlInputAddDismayInput({
    Key key,
    @required AddDismayPageBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
        condition: (olds, newS) => olds.url != newS.url,
        bloc: _bloc,
        builder: (
          BuildContext context,
          AddDismayPageState state,
        ) {
          return _AddDismayInputTextSection(
              key: const Key('URL'),
              label: 'URL',
              hintText: 'e.g https://www.dismay.com',
              helperText:
                   "Needs to be a valid URL including relevant protocol or IP",
              initialValue: state.url,
              onChanged: (String text) => _bloc.add(
                    UrlInputEvent(text),
                  ),
              next: () {
                _bloc.add(
                  NextPageEvent(state.page),
                );
              },
              validator: (text) {
                if (isValidURL(text)){
                  return null;
                } else {
                  return 'The Url needs to contain the web protocol (http/https)';
                }
              });
        });
  }
}

class _DashColorPickerAddDismayInput extends StatelessWidget {
  const _DashColorPickerAddDismayInput({
    Key key,
    @required AddDismayPageBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final AddDismayPageBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
      condition: (olds, newS) => olds.color != newS.color,
      bloc: _bloc,
      builder: (
        BuildContext context,
        AddDismayPageState state,
      ) {
        return Center(
          child: ListView(
            children: [
              Container(height: 50),
              ColorPicker(
                key: const Key('Color picker'),
                title: 'Dash color',
                current: state.color,
                onPick: (color) => _bloc.add(
                  ColorSelectedEvent(color),
                ),
                padding: null,
              ),
              const _AdddismayNextButton(),
            ],
          ),
        );
      },
    );
  }
}

class _TitlePageAddDismayInput extends StatelessWidget {
  const _TitlePageAddDismayInput({
    Key key,
    @required AddDismayPageBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final AddDismayPageBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
        condition: (olds, newS) => olds.title != newS.title,
        bloc: _bloc,
        builder: (
          BuildContext context,
          AddDismayPageState state,
        ) {
          return _AddDismayInputTextSection(
            key: const Key('Title'),
            label: 'Title',
            hintText: 'e.g Main dashboard',
            initialValue: state.title,
            onChanged: (String text) => _bloc.add(
              TitleInputEvent(text),
            ),
            next: () => _bloc.add(
              NextPageEvent(state.page),
            ),
          );
        });
  }
}

class _AddDismayInputTextSection extends StatelessWidget {
  final String label;
  final Function(String) onChanged;
  final Function() next;
  final String hintText;
  final String helperText;
  final String buttonText;
  final String initialValue;
  final String Function(String) validator;

  const _AddDismayInputTextSection(
      {Key key,
      this.label,
      this.hintText,
      this.helperText,
      this.onChanged,
      this.next,
      this.validator,
      @required this.initialValue,
      this.buttonText = 'next'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDismayPageBloc, AddDismayPageState>(
        condition: (olds, newS) => olds.color != newS.color,
        bloc: BlocProvider.of<AddDismayPageBloc>(context),
        builder: (
          BuildContext context,
          AddDismayPageState state,
        ) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ConstrainedTextfield(
                  label: label,
                  onChanged: onChanged,
                  initialValue: initialValue,
                  validator: validator,
                  hintText: hintText,
                  helperText: helperText,
                ),
                const _AdddismayNextButton(),
              ],
            ),
          );
        });
  }
}

class _ConstrainedTextfield extends StatelessWidget {
  const _ConstrainedTextfield({
    Key key,
    this.validator,
    this.hintText,
    this.helperText,
    @required this.label,
    @required this.onChanged,
    @required this.initialValue,
    this.maxWidth,
  }) : super(key: key);

  final String label;
  final Function(String) onChanged;
  final double maxWidth;
  final String initialValue;
  final String hintText;
  final String helperText;
  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: maxWidth ?? MediaQuery.of(context).size.width * 0.8),
      child: TextFormField(
        initialValue: initialValue,
        style: textStyleWhite,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          helperText: helperText,
          hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
          helperStyle: TextStyle(color: Colors.white.withAlpha(100)),
        ),
        onChanged: (String text) => onChanged(text),
        // onSaved:(String text) => onChanged(text),
        validator: validator,
        // validator: (text) {
        //   printInfo('Validator running with text $text');
        //   final validatorReturn = validator(text);
        //   printInfo('The incoming validator returned $validatorReturn');
        //   return validatorReturn;
        // }
      ),
    );
  }
}
